#!/bin/bash

# Digital Ocean Deployment Script for Matt's Blog
# This script automatically creates and deploys to Digital Ocean using doctl

set -e

# Configuration
DROPLET_NAME="${DROPLET_NAME:-mattblog-prod}"
DROPLET_SIZE="${DROPLET_SIZE:-s-1vcpu-1gb}"
DROPLET_REGION="${DROPLET_REGION:-nyc1}"
DROPLET_IMAGE="${DROPLET_IMAGE:-ubuntu-22-04-x64}"
SSH_KEY_NAME="${SSH_KEY_NAME:-}"
DOMAIN="${DOMAIN:-}"
DOCKER_REGISTRY="${DOCKER_REGISTRY:-}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
CONTAINER_NAME="mattblog"
ENABLE_SSL="${ENABLE_SSL:-true}"
ENABLE_LOAD_BALANCER="${ENABLE_LOAD_BALANCER:-false}"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if doctl is installed
    if ! command -v doctl &> /dev/null; then
        log_error "doctl is not installed. Please install it first:"
        log_info "  macOS: brew install doctl"
        log_info "  Linux: https://docs.digitalocean.com/reference/doctl/how-to/install/"
        exit 1
    fi
    
    # Check if doctl is authenticated
    if ! doctl account get &> /dev/null; then
        log_error "doctl is not authenticated. Please run: doctl auth init"
        exit 1
    fi
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Get or create SSH key
setup_ssh_key() {
    log_info "Setting up SSH key..."
    
    if [ -z "$SSH_KEY_NAME" ]; then
        # List existing SSH keys
        log_info "Available SSH keys:"
        doctl compute ssh-key list --format ID,Name,PublicKey
        
        # Ask user to select or create new
        read -p "Enter SSH key name (or press Enter to create new): " SSH_KEY_NAME
        
        if [ -z "$SSH_KEY_NAME" ]; then
            SSH_KEY_NAME="mattblog-key-$(date +%s)"
            log_info "Creating new SSH key: $SSH_KEY_NAME"
            
            # Check if default SSH key exists
            if [ -f ~/.ssh/id_rsa.pub ]; then
                log_info "Using existing SSH key from ~/.ssh/id_rsa.pub"
                doctl compute ssh-key import "$SSH_KEY_NAME" --public-key-file ~/.ssh/id_rsa.pub
            else
                log_error "No SSH key found at ~/.ssh/id_rsa.pub"
                log_info "Please generate an SSH key: ssh-keygen -t rsa -b 4096"
                exit 1
            fi
        fi
    fi
    
    # Verify SSH key exists
    if ! doctl compute ssh-key get "$SSH_KEY_NAME" &> /dev/null; then
        log_error "SSH key '$SSH_KEY_NAME' not found"
        exit 1
    fi
    
    SSH_KEY_ID=$(doctl compute ssh-key get "$SSH_KEY_NAME" --format ID --no-header)
    log_success "Using SSH key: $SSH_KEY_NAME (ID: $SSH_KEY_ID)"
}

# Create or get existing droplet
setup_droplet() {
    log_info "Setting up droplet..."
    
    # Check if droplet already exists
    if doctl compute droplet list --format Name,Status | grep -q "$DROPLET_NAME"; then
        log_info "Droplet '$DROPLET_NAME' already exists, using existing one"
        DROPLET_ID=$(doctl compute droplet list --format ID,Name --no-header | grep "$DROPLET_NAME" | awk '{print $1}')
        DROPLET_IP=$(doctl compute droplet get "$DROPLET_ID" --format PublicIPv4 --no-header)
        log_success "Using existing droplet: $DROPLET_NAME (IP: $DROPLET_IP)"
    else
        log_info "Creating new droplet: $DROPLET_NAME"
        
        # Create droplet
        DROPLET_ID=$(doctl compute droplet create "$DROPLET_NAME" \
            --size "$DROPLET_SIZE" \
            --image "$DROPLET_IMAGE" \
            --region "$DROPLET_REGION" \
            --ssh-keys "$SSH_KEY_ID" \
            --format ID --no-header)
        
        log_info "Droplet created with ID: $DROPLET_ID"
        log_info "Waiting for droplet to be ready..."
        
        # Wait for droplet to be ready
        while true; do
            STATUS=$(doctl compute droplet get "$DROPLET_ID" --format Status --no-header)
            if [ "$STATUS" = "active" ]; then
                break
            fi
            log_info "Droplet status: $STATUS, waiting..."
            sleep 10
        done
        
        # Get droplet IP
        DROPLET_IP=$(doctl compute droplet get "$DROPLET_ID" --format PublicIPv4 --no-header)
        log_success "Droplet ready: $DROPLET_NAME (IP: $DROPLET_IP)"
        
        # Wait a bit more for SSH to be available
        log_info "Waiting for SSH to be available..."
        sleep 30
    fi
}

# Setup domain and DNS
setup_domain() {
    if [ -z "$DOMAIN" ]; then
        read -p "Enter your domain (or press Enter to skip): " DOMAIN
    fi
    
    if [ -n "$DOMAIN" ]; then
        log_info "Setting up domain: $DOMAIN"
        
        # Check if domain exists in Digital Ocean
        if ! doctl domains list --format Name | grep -q "$DOMAIN"; then
            log_info "Domain '$DOMAIN' not found in Digital Ocean, adding it..."
            doctl domains create "$DOMAIN"
        fi
        
        # Create A record pointing to droplet
        log_info "Creating A record for $DOMAIN pointing to $DROPLET_IP"
        doctl domains records create "$DOMAIN" --record-type A --record-name "@" --record-data "$DROPLET_IP"
        
        # Create www subdomain
        log_info "Creating www subdomain record"
        doctl domains records create "$DOMAIN" --record-type A --record-name "www" --record-data "$DROPLET_IP"
        
        log_success "Domain setup completed: $DOMAIN"
    else
        log_info "Skipping domain setup"
    fi
}

# Setup load balancer (optional)
setup_load_balancer() {
    if [ "$ENABLE_LOAD_BALANCER" = "true" ]; then
        log_info "Setting up load balancer..."
        
        LB_NAME="$DROPLET_NAME-lb"
        
        # Check if load balancer exists
        if ! doctl compute load-balancer list --format Name | grep -q "$LB_NAME"; then
            log_info "Creating load balancer: $LB_NAME"
            
            # Create load balancer
            doctl compute load-balancer create \
                --name "$LB_NAME" \
                --region "$DROPLET_REGION" \
                --droplet-ids "$DROPLET_ID" \
                --forwarding-rules "protocol:http,entry_port:80,entry_protocol:http,target_port:80,target_protocol:http" \
                --forwarding-rules "protocol:https,entry_port:443,entry_protocol:https,target_port:80,target_protocol:http" \
                --health-check "protocol:http,port:80,path:/health" \
                --sticky-sessions "type:http_cookie"
            
            log_success "Load balancer created: $LB_NAME"
        else
            log_info "Load balancer '$LB_NAME' already exists"
        fi
    else
        log_info "Skipping load balancer setup"
    fi
}

# Build Docker image
build_image() {
    log_info "Building Docker image..."
    
    if [ -n "$DOCKER_REGISTRY" ]; then
        docker build -t "$DOCKER_REGISTRY/mattblog:$IMAGE_TAG" .
        docker push "$DOCKER_REGISTRY/mattblog:$IMAGE_TAG"
        log_success "Image built and pushed to registry"
    else
        docker build -t "mattblog:$IMAGE_TAG" .
        log_success "Image built locally"
    fi
}

# Deploy to droplet
deploy_to_droplet() {
    log_info "Deploying to Digital Ocean droplet at $DROPLET_IP..."
    
    # Wait for SSH to be available
    log_info "Testing SSH connection..."
    for i in {1..30}; do
        if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no root@"$DROPLET_IP" "echo 'SSH connection successful'" 2>/dev/null; then
            break
        fi
        if [ $i -eq 30 ]; then
            log_error "SSH connection failed after 30 attempts"
            exit 1
        fi
        log_info "SSH not ready, retrying in 10 seconds... (attempt $i/30)"
        sleep 10
    done
    
    # Install Docker on droplet if not present
    log_info "Installing Docker on droplet..."
    ssh -o StrictHostKeyChecking=no root@"$DROPLET_IP" "
        if ! command -v docker &> /dev/null; then
            curl -fsSL https://get.docker.com -o get-docker.sh
            sh get-docker.sh
            systemctl enable docker
            systemctl start docker
        fi
        
        if ! command -v docker-compose &> /dev/null; then
            curl -L \"https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-\$(uname -s)-\$(uname -m)\" -o /usr/local/bin/docker-compose
            chmod +x /usr/local/bin/docker-compose
        fi
    "
    
    # Create deployment directory on droplet
    ssh -o StrictHostKeyChecking=no root@"$DROPLET_IP" "mkdir -p ~/mattblog"
    
    # Copy deployment files
    scp -o StrictHostKeyChecking=no docker-compose.yml root@"$DROPLET_IP":~/mattblog/
    scp -o StrictHostKeyChecking=no nginx.conf root@"$DROPLET_IP":~/mattblog/
    
    # Create production docker-compose file
    cat > docker-compose.prod.yml << EOF
version: '3.8'

services:
  mattblog:
    image: ${DOCKER_REGISTRY:-mattblog}:${IMAGE_TAG}
    restart: unless-stopped
    environment:
      - NODE_ENV=production
      - NEXT_TELEMETRY_DISABLED=1
    networks:
      - mattblog-network

  nginx:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - mattblog
    networks:
      - mattblog-network

networks:
  mattblog-network:
    driver: bridge
EOF
    
    scp -o StrictHostKeyChecking=no docker-compose.prod.yml root@"$DROPLET_IP":~/mattblog/
    
    # Deploy on droplet
    ssh -o StrictHostKeyChecking=no root@"$DROPLET_IP" "cd ~/mattblog && \
        docker-compose -f docker-compose.prod.yml down && \
        docker-compose -f docker-compose.prod.yml pull && \
        docker-compose -f docker-compose.prod.yml up -d"
    
    log_success "Deployment completed"
}

# Setup SSL certificates
setup_ssl() {
    log_info "Setting up SSL certificates..."
    
    # Create SSL directory
    ssh -o StrictHostKeyChecking=no root@"$DROPLET_IP" "mkdir -p ~/mattblog/ssl"
    
    if [ "$ENABLE_SSL" = "true" ] && [ -n "$DOMAIN" ]; then
        # Try to install certbot and get Let's Encrypt certificate
        log_info "Attempting to get Let's Encrypt certificate for $DOMAIN..."
        
        ssh -o StrictHostKeyChecking=no root@"$DROPLET_IP" "
            if ! command -v certbot &> /dev/null; then
                apt-get update
                apt-get install -y certbot
            fi
            
            # Stop nginx temporarily for certbot
            cd ~/mattblog && docker-compose -f docker-compose.prod.yml stop nginx
            
            # Get certificate
            if certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN; then
                # Copy certificates to nginx ssl directory
                cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem ~/mattblog/ssl/cert.pem
                cp /etc/letsencrypt/live/$DOMAIN/privkey.pem ~/mattblog/ssl/key.pem
                echo 'SSL certificates installed successfully'
            else
                echo 'Failed to get Let\'s Encrypt certificate, creating self-signed'
                openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
                    -keyout ~/mattblog/ssl/key.pem -out ~/mattblog/ssl/cert.pem \
                    -subj '/C=US/ST=State/L=City/O=Organization/CN=$DOMAIN'
            fi
            
            # Restart nginx
            cd ~/mattblog && docker-compose -f docker-compose.prod.yml start nginx
        "
        
        log_success "SSL setup completed"
    else
        # Create self-signed certificate
        ssh -o StrictHostKeyChecking=no root@"$DROPLET_IP" "cd ~/mattblog/ssl && \
            openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout key.pem -out cert.pem \
            -subj '/C=US/ST=State/L=City/O=City/O=Organization/CN=localhost'"
        
        log_success "Self-signed SSL certificate created"
    fi
}

# Health check
health_check() {
    log_info "Performing health check..."
    
    # Wait for services to start
    sleep 15
    
    # Check if services are running
    if ssh -o StrictHostKeyChecking=no root@"$DROPLET_IP" "cd ~/mattblog && docker-compose -f docker-compose.prod.yml ps | grep -q 'Up'"; then
        log_success "Services are running"
        
        # Test HTTP response
        if curl -s -f "http://$DROPLET_IP" > /dev/null; then
            log_success "HTTP endpoint is responding"
        else
            log_warning "HTTP endpoint is not responding"
        fi
        
        # Test HTTPS response (if SSL is configured)
        if curl -s -f -k "https://$DROPLET_IP" > /dev/null; then
            log_success "HTTPS endpoint is responding"
        else
            log_warning "HTTPS endpoint is not responding (check SSL configuration)"
        fi
        
        # Test domain if configured
        if [ -n "$DOMAIN" ]; then
            log_info "Testing domain: $DOMAIN"
            if curl -s -f "http://$DOMAIN" > /dev/null; then
                log_success "Domain HTTP endpoint is responding"
            else
                log_warning "Domain HTTP endpoint is not responding (DNS may still be propagating)"
            fi
            
            if curl -s -f -k "https://$DOMAIN" > /dev/null; then
                log_success "Domain HTTPS endpoint is responding"
            else
                log_warning "Domain HTTPS endpoint is not responding"
            fi
        fi
        
    else
        log_error "Services are not running properly"
        exit 1
    fi
}

# Show deployment summary
show_summary() {
    log_success "Deployment completed successfully!"
    log_info ""
    log_info "🌐 Access your blog:"
    log_info "  HTTP:  http://$DROPLET_IP"
    log_info "  HTTPS: https://$DROPLET_IP"
    
    if [ -n "$DOMAIN" ]; then
        log_info ""
        log_info "🌍 Domain access:"
        log_info "  HTTP:  http://$DOMAIN"
        log_info "  HTTPS: https://$DOMAIN"
        log_info ""
        log_info "📝 Note: DNS changes may take up to 24 hours to propagate"
    fi
    
    log_info ""
    log_info "🔧 Management commands:"
    log_info "  View logs: ssh root@$DROPLET_IP 'cd ~/mattblog && docker-compose -f docker-compose.prod.yml logs -f'"
    log_info "  Stop services: ssh root@$DROPLET_IP 'cd ~/mattblog && docker-compose -f docker-compose.prod.yml down'"
    log_info "  Restart services: ssh root@$DROPLET_IP 'cd ~/mattblog && docker-compose -f docker-compose.prod.yml restart'"
    log_info ""
    log_info "📊 Digital Ocean resources:"
    log_info "  Droplet: $DROPLET_NAME (ID: $DROPLET_ID)"
    if [ "$ENABLE_LOAD_BALANCER" = "true" ]; then
        log_info "  Load Balancer: $DROPLET_NAME-lb"
    fi
    if [ -n "$DOMAIN" ]; then
        log_info "  Domain: $DOMAIN"
    fi
}

# Main deployment function
main() {
    log_info "🚀 Starting automated Digital Ocean deployment..."
    
    check_prerequisites
    setup_ssh_key
    setup_droplet
    setup_domain
    setup_load_balancer
    build_image
    deploy_to_droplet
    setup_ssl
    health_check
    show_summary
    
    log_success "🎉 Deployment completed successfully!"
}

# Run main function
main "$@"
