#!/bin/bash

# 获取当前日期并格式化为 "YYYY-MM-DD" 格式
current_date=$(date +"%Y-%m-%d")

# 构造文件名，例如：2023-09-10.md
file_name="/home/auto_src/targets/$current_date.md"

# 1. 从当前日期文件中逐行读取子域名，并使用subfinder进行子域名收集
while IFS= read -r line
do
    subfinder -d "$line" >> sub.txt
done < "$file_name"


# 2. 从sub.txt中读取子域名并进行IP解析

echo "开始ip解析" | notify -silent
cat sub.txt | xargs -I {} host {} | awk '/has address/ { print $4 }' >> ips.txt



echo "开始端口扫描" | notify -silent
# 3. 使用masscan进行IP端口扫描
masscan -iL ips.txt -p 1-65535 --rate 10000 -oG ip_port.txt

# 4. 使用nabbu进行子域名端口扫描
nabbu -i sub.txt -p  -p 80,443,8080,2053,2087,2096,8443,2083,2086,2095,8880,2052,2082,3443,8791,8887,8888,444,9443,2443,10000,10001,8082,8444,20000,8081,8445,8446,8447 -o sub_port.txt



echo "开始httpx验活" | notify -silent
# 5. 使用httpx进行活动主机验证
httpx -l "ip_port.txt" -o "ips_alive.txt"
httpx -l "sub_port.txt" -o "sub_alive.txt"

# 合并活动验证后的文件为一个文件
cat ips_alive.txt sub_alive.txt > combined_alive.txt


echo "开始nuclei扫描" | notify -silent
# 使用nuclei扫描
nuclei -l combined_alive.txt -t /path/to/nuclei-templates -severity critical,medium,high -o nuclei_results.txt | notify -silent



echo "开始xray扫描" | notify -silent
# 使用xray扫描
xray webscan --url-list combined_alive.txt -o xray_results.txt | notify -silent


echo "扫描结束，清理战场ing！" | notify -silent

# 清理临时文件
rm sub.txt ips.txt
