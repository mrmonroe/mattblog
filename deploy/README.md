# 🚀 Automated Digital Ocean Deployment

This deployment system automatically creates everything needed to serve your blog from a browser using Digital Ocean's infrastructure.

## 📋 Prerequisites

### 1. Install `doctl` (Digital Ocean CLI)

#### **macOS**
```bash
brew install doctl
```

#### **Linux**
```bash
# Download the latest version
curl -sL https://github.com/digitalocean/doctl/releases/latest/download/doctl-1.94.0-linux-amd64.tar.gz | tar -xzv

# Move to PATH
sudo mv doctl /usr/local/bin
```

#### **Windows**
Download from: https://github.com/digitalocean/doctl/releases

### 2. Authenticate with Digital Ocean

```bash
# Initialize authentication
doctl auth init

# Enter your Digital Ocean API token when prompted
# Get your token from: https://cloud.digitalocean.com/account/api/tokens
```

### 3. Verify Installation

```bash
# Check version
doctl version

# Check authentication
doctl account get
```

## 🎯 One-Command Deployment

### **Via CLI**
```bash
# Interactive deployment
mattblog deploy

# Follow the prompts for configuration
```

### **Via Script**
```bash
# Direct script execution
./deploy/do-deploy.sh
```

## ⚙️ Configuration Options

### **Environment Variables**
```bash
export DROPLET_NAME="mattblog-prod"           # Droplet name
export DROPLET_SIZE="s-1vcpu-1gb"            # Droplet size
export DROPLET_REGION="nyc1"                 # Region
export DOMAIN="yourdomain.com"               # Your domain
export ENABLE_LOAD_BALANCER="true"           # Enable load balancer
export DOCKER_REGISTRY="your-registry"       # Docker registry
export IMAGE_TAG="latest"                    # Image tag
```

### **Droplet Sizes**
- **s-1vcpu-1gb**: $6/month (Basic blog)
- **s-1vcpu-2gb**: $12/month (Recommended)
- **s-2vcpu-2gb**: $18/month (High traffic)

### **Regions**
- **nyc1**: New York
- **sfo3**: San Francisco
- **lon1**: London
- **fra1**: Frankfurt
- **sgp1**: Singapore

## 🔄 What Gets Created

### **1. Infrastructure**
- ✅ SSH key (or use existing)
- ✅ Droplet with Ubuntu 22.04
- ✅ Docker and Docker Compose
- ✅ Firewall rules

### **2. Application**
- ✅ Docker image build
- ✅ Container deployment
- ✅ Nginx reverse proxy
- ✅ SSL certificates (Let's Encrypt or self-signed)

### **3. Networking**
- ✅ Domain DNS records (if provided)
- ✅ Load balancer (if enabled)
- ✅ Health checks
- ✅ SSL/TLS termination

## 🌐 Access Your Blog

### **After Deployment**
- **IP Access**: `http://your_droplet_ip`
- **Domain Access**: `https://yourdomain.com` (if configured)
- **Health Check**: `/health` endpoint

### **SSL Certificates**
- **Automatic**: Let's Encrypt (if domain provided)
- **Fallback**: Self-signed certificate
- **Manual**: Place custom certificates in `ssl/` directory

## 🔧 Management Commands

### **View Logs**
```bash
ssh root@your_droplet_ip 'cd ~/mattblog && docker-compose -f docker-compose.prod.yml logs -f'
```

### **Restart Services**
```bash
ssh root@your_droplet_ip 'cd ~/mattblog && docker-compose -f docker-compose.prod.yml restart'
```

### **Update Deployment**
```bash
# Rebuild and redeploy
mattblog docker-build
mattblog deploy
```

### **Stop Services**
```bash
ssh root@your_droplet_ip 'cd ~/mattblog && docker-compose -f docker-compose.prod.yml down'
```

## 📊 Digital Ocean Resources

### **View Resources**
```bash
# List droplets
doctl compute droplet list

# List domains
doctl domains list

# List load balancers
doctl compute load-balancer list

# List SSH keys
doctl compute ssh-key list
```

### **Delete Resources**
```bash
# Delete droplet
doctl compute droplet delete your_droplet_id

# Delete domain
doctl domains delete yourdomain.com

# Delete load balancer
doctl compute load-balancer delete your_lb_id
```

## 🚨 Troubleshooting

### **Common Issues**

#### **doctl not found**
```bash
# Ensure doctl is in PATH
which doctl
# Add to PATH if needed
export PATH=$PATH:/path/to/doctl
```

#### **Authentication failed**
```bash
# Re-authenticate
doctl auth init
# Verify token
doctl account get
```

#### **SSH connection failed**
```bash
# Check droplet status
doctl compute droplet get your_droplet_id

# Wait for droplet to be ready
# SSH becomes available ~1 minute after status shows "active"
```

#### **Docker build failed**
```bash
# Check Docker is running
docker --version
docker-compose --version

# Ensure you're in the project directory
pwd
ls Dockerfile
```

### **Get Help**
```bash
# CLI help
mattblog help

# doctl help
doctl help

# View deployment logs
./deploy/do-deploy.sh 2>&1 | tee deployment.log
```

## 💰 Cost Estimation

### **Monthly Costs**
- **Basic Droplet**: $6-18/month
- **Load Balancer**: $12/month (if enabled)
- **Domain**: $12/year (if purchased through DO)
- **Bandwidth**: Included in droplet cost

### **Total Monthly**
- **Basic Setup**: $6-18/month
- **With Load Balancer**: $18-30/month
- **Production Ready**: $30-50/month

## 🎉 Success!

After deployment, your blog will be:
- ✅ **Accessible worldwide** via IP or domain
- ✅ **SSL secured** with automatic certificate renewal
- ✅ **Load balanced** (if enabled)
- ✅ **Auto-scaling ready** for future growth
- ✅ **Production hardened** with security best practices

Your blog is now enterprise-ready! 🚀
