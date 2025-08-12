#!/bin/bash

# Digital Ocean Deployment Script for Matt's Blog
# This script deploys the blog to a Digital Ocean droplet

set -e

# Configuration
DROPLET_IP="${DROPLET_IP:-}"
DROPLET_USER="${DROPLET_USER:-root}"
SSH_KEY="${SSH_KEY:-~/.ssh/id_rsa}"
DOCKER_REGISTRY="${DOCKER_REGISTRY:-}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
CONTAINER_NAME="mattblog"

# Colors for output
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
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    if [ -z "$DROPLET_IP" ]; then
        log_error "DROPLET_IP environment variable is not set."
        log_info "Please set it: export DROPLET_IP=your_droplet_ip"
        exit 1
    fi
    
    if [ ! -f "$SSH_KEY" ]; then
        log_error "SSH key not found at $SSH_KEY"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
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
    
    # Create deployment directory on droplet
    ssh -i "$SSH_KEY" "$DROPLET_USER@$DROPLET_IP" "mkdir -p ~/mattblog"
    
    # Copy deployment files
    scp -i "$SSH_KEY" docker-compose.yml "$DROPLET_USER@$DROPLET_IP:~/mattblog/"
    scp -i "$SSH_KEY" nginx.conf "$DROPLET_USER@$DROPLET_IP:~/mattblog/"
    
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
    
    scp -i "$SSH_KEY" docker-compose.prod.yml "$DROPLET_USER@$DROPLET_IP:~/mattblog/"
    
    # Deploy on droplet
    ssh -i "$SSH_KEY" "$DROPLET_USER@$DROPLET_IP" "cd ~/mattblog && \
        docker-compose -f docker-compose.prod.yml down && \
        docker-compose -f docker-compose.prod.yml pull && \
        docker-compose -f docker-compose.prod.yml up -d"
    
    log_success "Deployment completed"
}

# Setup SSL certificates
setup_ssl() {
    log_info "Setting up SSL certificates..."
    
    # Create SSL directory
    ssh -i "$SSH_KEY" "$DROPLET_USER@$DROPLET_IP" "mkdir -p ~/mattblog/ssl"
    
    # Check if Let's Encrypt is available
    if ssh -i "$SSH_KEY" "$DROPLET_USER@$DROPLET_IP" "command -v certbot &> /dev/null"; then
        log_info "Certbot found. You can run: ssh -i $SSH_KEY $DROPLET_USER@$DROPLET_IP 'cd ~/mattblog && certbot certonly --standalone -d yourdomain.com'"
    else
        log_warning "Certbot not found. Please install it or manually add SSL certificates to ~/mattblog/ssl/"
    fi
    
    # Create self-signed certificate for testing
    ssh -i "$SSH_KEY" "$DROPLET_USER@$DROPLET_IP" "cd ~/mattblog/ssl && \
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout key.pem -out cert.pem \
        -subj '/C=US/ST=State/L=City/O=Organization/CN=localhost'"
    
    log_success "SSL setup completed (self-signed certificate created)"
}

# Health check
health_check() {
    log_info "Performing health check..."
    
    # Wait for services to start
    sleep 10
    
    # Check if services are running
    if ssh -i "$SSH_KEY" "$DROPLET_USER@$DROPLET_IP" "cd ~/mattblog && docker-compose -f docker-compose.prod.yml ps | grep -q 'Up'"; then
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
        
    else
        log_error "Services are not running properly"
        exit 1
    fi
}

# Main deployment function
main() {
    log_info "Starting deployment to Digital Ocean..."
    
    check_prerequisites
    build_image
    deploy_to_droplet
    setup_ssl
    health_check
    
    log_success "Deployment completed successfully!"
    log_info "Your blog should be available at:"
    log_info "  HTTP:  http://$DROPLET_IP"
    log_info "  HTTPS: https://$DROPLET_IP (self-signed certificate)"
    log_info ""
    log_info "To view logs: ssh -i $SSH_KEY $DROPLET_USER@$DROPLET_IP 'cd ~/mattblog && docker-compose -f docker-compose.prod.yml logs -f'"
    log_info "To stop services: ssh -i $SSH_KEY $DROPLET_USER@$DROPLET_IP 'cd ~/mattblog && docker-compose -f docker-compose.prod.yml down'"
}

# Run main function
main "$@"
