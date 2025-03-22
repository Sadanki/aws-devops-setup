# AWS DevOps Setup - Task 1: System Monitoring  

## 📌 Overview  
This task focuses on setting up system monitoring on an AWS EC2 instance to track CPU, memory, and disk usage, ensuring optimal performance.  

## 🛠️ Steps to Complete Task 1  

### 1️⃣ **Launch an AWS EC2 Instance**  
- Go to **AWS Console → EC2 → Launch Instance**  
- Select **Ubuntu Server 24.04 LTS (HVM), EBS General Purpose (SSD)**  
- Choose **Instance Type:** `t2.micro` (Free Tier)  
- Configure the **Security Group:**  
  - Allow **SSH (port 22)** from **My IP**  
  - Allow **ICMP (All Traffic)** for monitoring  
- Configure **Storage:**  
  - **Root Volume (10GB, GP3 SSD)** → `/`  
  - **Log Volume (5GB, GP3 SSD)** → `/var/logs/monitoring`  
- Click **Launch**, create a new key pair (`my-key.pem`), and download it.  

### 2️⃣ **Connect to the EC2 Instance**  
- Open **Git Bash (Windows) / Terminal (Mac/Linux)**  
- Move to the key’s location and set permissions:  
  ```bash
  chmod 400 my-key.pem
  ```  
- Connect via SSH:  
  ```bash
  ssh -i my-key.pem ubuntu@<your-instance-ip>
  ```  

### 3️⃣ **Install Monitoring Tools**  
- Update package lists:  
  ```bash
  sudo apt update && sudo apt upgrade -y
  ```  
- Install monitoring tools:  
  ```bash
  sudo apt install -y htop nmon
  ```  
- Verify installation:  
  ```bash
  htop
  nmon
  ```  

### 4️⃣ **Set Up Disk & Process Monitoring**  
- Check **disk usage**:  
  ```bash
  df -h
  du -sh /var/log
  ```  
- Check **CPU & Memory usage**:  
  ```bash
  free -m
  top
  ```  

### 5️⃣ **Create System Monitoring Script**  
- Create the script:  
  ```bash
  sudo nano /usr/local/bin/system_monitor.sh
  ```  
- Add the following:  
  ```bash
  #!/bin/bash
  echo "System Monitoring Report - $(date)" >> /var/logs/monitoring/system_monitor.log
  echo "CPU Usage:" >> /var/logs/monitoring/system_monitor.log
  top -bn1 | head -n 10 >> /var/logs/monitoring/system_monitor.log
  echo "Disk Usage:" >> /var/logs/monitoring/system_monitor.log
  df -h >> /var/logs/monitoring/system_monitor.log
  echo "Memory Usage:" >> /var/logs/monitoring/system_monitor.log
  free -m >> /var/logs/monitoring/system_monitor.log
  echo "-------------------------" >> /var/logs/monitoring/system_monitor.log
  ```  
- Save & Exit (`Ctrl + X → Y → Enter`).  
- Give execute permissions:  
  ```bash
  sudo chmod +x /usr/local/bin/system_monitor.sh
  ```  

### 6️⃣ **Schedule Script with Crontab**  
- Open crontab:  
  ```bash
  crontab -e
  ```  
- Add this line at the bottom (runs every 5 minutes):  
  ```bash
  */5 * * * * /usr/local/bin/system_monitor.sh
  ```  
- Save & Exit.  

### 7️⃣ **Verify Logs**  
- Check if the script runs:  
  ```bash
  cat /var/logs/monitoring/system_monitor.log
  ```  
- Check cron jobs running:  
  ```bash
  sudo grep CRON /var/log/syslog
  ```  

### 8️⃣ **Push Files to GitHub**  
#### **Setup Git**  
```bash
git config --global user.name "your-github-username"
git config --global user.email "your-email@example.com"
```  
#### **Create a Project Folder & Initialize Git**  
```bash
mkdir -p ~/aws-monitoring-task
cd ~/aws-monitoring-task
git init
```  
#### **Move Log & Script Files**  
```bash
sudo mv /usr/local/bin/system_monitor.sh ~/aws-monitoring-task/
sudo mv /var/logs/monitoring/system_monitor.log ~/aws-monitoring-task/
```  
#### **Commit & Push to GitHub**  
```bash
git add .
git commit -m "Added system monitoring setup"
git remote add origin git@github.com:your-username/aws-devops-setup.git
git branch -M main
git push -u origin main
```  

### 9️⃣ **Stop the Instance (To Avoid Charges, if not needed)**  
```bash
exit  # To disconnect from EC2
```
- Go to **AWS Console → EC2 → Select Instance → Actions → Instance State → Stop**  

---

## ✅ Task 1 Completed! 🎉  
This completes the **System Monitoring Setup**. 🚀  

# 🚀 **Task 2: User Management & Access Control**  

## 🔥 **Mission Brief**  
Welcome to **Task 2**, where we transform an open system into a **secure and structured workspace**! Your challenge? **Onboard new developers, lock down access, and enforce security policies** to maintain a rock-solid environment.  

👥 **New Users**: Sarah & Mike  
📂 **Goal**: Assign them **isolated, secure workspaces**  
🔐 **Security Focus**: Strong passwords & controlled access  

---

## 🛠️ **Deployment Steps**  

### 🎯 **1️⃣ Creating User Accounts**  
First, let’s create **Sarah** and **Mike** as system users:  
```bash
sudo useradd -m -c "Sarah Tessera, Developer" -s /bin/bash sarah  
sudo useradd -m -c "Mike Alam, Developer" -s /bin/bash mike  
```
🔥 **Set secure passwords:**  
```bash
sudo passwd sarah  
sudo passwd mike  
```

---

### 📂 **2️⃣ Setting Up Secure Workspaces**  
Each developer needs a private **workspace** to keep their work secure.  
```bash
sudo mkdir -p /home/sarah/workspace  
sudo mkdir -p /home/mike/workspace  
```
Assign ownership to the respective users:  
```bash
sudo chown sarah:sarah /home/sarah/workspace  
sudo chown mike:mike /home/mike/workspace  
```
🚧 **Locking down access** (only the owner can access their directory):  
```bash
sudo chmod 700 /home/sarah/workspace  
sudo chmod 700 /home/mike/workspace  
```

---

### 🔐 **3️⃣ Enforcing a Strong Password Policy**  
To maintain security, enforce **password complexity and expiration rules**:  

Edit **password policy configuration**:  
```bash
sudo nano /etc/security/pwquality.conf
```
Add or modify the following lines:  
```
minlen = 12        # Minimum password length  
dcredit = -1       # At least one digit  
ucredit = -1       # At least one uppercase letter  
lcredit = -1       # At least one lowercase letter  
ocredit = -1       # At least one special character  
retry = 3          # Allow 3 retries before failure  
```
💾 **Save and exit** (`CTRL + X → Y → ENTER`)

---

### 🔄 **4️⃣ Setting Password Expiration Rules**  
Ensure passwords **expire every 30 days**:  
```bash
sudo chage -M 30 sarah  
sudo chage -M 30 mike  
```
Check expiration settings:  
```bash
sudo chage -l sarah  
sudo chage -l mike  
```

---

## ✅ **Mission Accomplished!**  
🎯 **Sarah and Mike now have:**  
✔️ **Secure accounts**  
✔️ **Private workspaces**  
✔️ **Strong password policies**  

🔒 **Security is not an option—it's a necessity!** 🚀



Here is your README file formatted like the image:

---

# 🚀 Task 3: Backup Configuration for Web Servers  

## 🔥 Mission Brief  

Welcome to **Task 3**, where we ensure **data integrity and recovery** by configuring automated backups for web servers. Your challenge? Implement a **scheduled backup system** to protect critical web server files.  

👩‍💻 **Users:** Sarah & Mike  
🎯 **Goal:** Automate backups for their respective web servers  
🔐 **Security Focus:** Reliable, verifiable backups & secure storage  

---  

## 🛠 Deployment Steps  

### 🎯 1. Creating Backup Scripts  

First, let's create **backup scripts** for Sarah’s Apache server and Mike’s Nginx server:  

```
#!/bin/bash  
# Apache Backup Script  
timestamp=$(date +'%Y-%m-%d')  
tar -czf /backups/apache_backup_$timestamp.tar.gz /etc/httpd/ /var/www/html/  
```

```
#!/bin/bash  
# Nginx Backup Script  
timestamp=$(date +'%Y-%m-%d')  
tar -czf /backups/nginx_backup_$timestamp.tar.gz /etc/nginx/ /usr/share/nginx/html/  
```

Set executable permissions:  

```
chmod +x apache_backup.sh  
chmod +x nginx_backup.sh  
```

---

### ⏰ 2. Scheduling Backups with Cron  

Schedule backups to run **every Tuesday at 12:00 AM** by adding these lines to the crontab (`crontab -e`):  

```
0 0 * * 2 /path/to/apache_backup.sh >> /var/log/apache_backup.log 2>&1  
0 0 * * 2 /path/to/nginx_backup.sh >> /var/log/nginx_backup.log 2>&1  
```

---

### ✅ 3. Verifying Backup Integrity  

After a scheduled backup, check if backup files exist:  

```
ls -lh /backups/  
```

Verify the contents of the backup:  

```
tar -tzf /backups/apache_backup_YYYY-MM-DD.tar.gz  
tar -tzf /backups/nginx_backup_YYYY-MM-DD.tar.gz  
```

---

### 📜 Expected Output  

✔️ **Cron job configurations for Sarah and Mike**  
✔️ **Backup files are created in `/backups/`**  
✔️ **Verification log showing backup integrity**  

---

