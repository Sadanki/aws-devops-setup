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

Let me know if you need any modifications!
