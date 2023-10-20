## About
✂一个Bughunter自用的裁缝工具！
## Usage
1. `docker build -t src:v1 .`
2. `docker run -it --name src_1 src:v1 /bin/zsh` 
3. `docker exec -it src_1 /bin/zsh`

 **从容器复制文件到宿主系统**： 
```bash 
docker cp <container_id_or_name>:<container_path> <host_path> 
``` 
- `<container_id_or_name>` 是容器的 ID 或名称。 
- `<container_path>` 是容器内文件或目录的路径。 
- `<host_path>` 是要在宿主系统上创建文件或目录的路径。


