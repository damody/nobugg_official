# NoBugg DOTA2 英雄資訊網站部署指南

這是一個使用 Lapis 框架開發的 DOTA2 信長英雄資訊網站，支援多語言（中文簡體/繁體、英文、日文）。

## 系統需求

- Ubuntu 24.04 LTS (或其他 Debian 系統)
- OpenResty (Nginx + LuaJIT)
- Redis 服務器
- 各種 Lua 模組

## 安裝步驟

### 1. 添加 OpenResty 官方軟體源

```bash
# 下載並添加 OpenResty GPG key
wget -qO - https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/openresty.gpg

# 添加 OpenResty 軟體源
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/openresty.list

# 更新軟體包列表
sudo apt update
```

### 2. 安裝基本依賴

```bash
# 安裝 OpenResty
sudo apt install openresty

# 安裝 LuaRocks 和編譯工具
sudo apt install luarocks build-essential libssl-dev

# 安裝 Redis 服務器
sudo apt install redis-server

# 安裝 PCRE 開發套件
sudo apt install libpcre3-dev
```

### 3. 啟動 Redis 服務

```bash
# 啟動 Redis 服務
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

### 4. 安裝 Lua 模組

```bash
# 安裝 Lapis 框架
sudo luarocks install lapis

# 安裝 Redis Lua 客戶端
sudo luarocks install redis-lua

# 安裝其他必要模組
sudo luarocks install luasocket
sudo luarocks install inspect
sudo luarocks install luafilesystem
sudo luarocks install lrexlib-pcre
```

### 5. 測試模組安裝

```bash
# 測試 lfs 模組
lua -e "require('lfs'); print('lfs module loaded successfully')"

# 測試 rex_pcre 模組
lua -e "require('rex_pcre'); print('rex_pcre module loaded successfully')"
```

## 啟動應用

### 開發環境

```bash
# 進入專案目錄
cd /path/to/nobugg_official

# 方式1: 使用 Lapis 命令
lapis server development

# 方式2: 直接使用 OpenResty
openresty -p `pwd`/ -c nginx.conf
```

### 生產環境

創建系統服務文件：

```bash
sudo tee /etc/systemd/system/nobugg.service > /dev/null <<EOF
[Unit]
Description=NoBugg DOTA2 Hero Website
After=network.target redis.service

[Service]
Type=forking
User=www-data
Group=www-data
WorkingDirectory=/path/to/nobugg_official
ExecStart=/usr/local/openresty/bin/openresty -p /path/to/nobugg_official/ -c nginx.conf
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=mixed
TimeoutStopSec=5
KillSignal=SIGQUIT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# 重新載入 systemd 配置
sudo systemctl daemon-reload

# 啟用並啟動服務
sudo systemctl enable nobugg.service
sudo systemctl start nobugg.service

# 檢查服務狀態
sudo systemctl status nobugg.service
```

## 訪問網站

應用啟動後，可以通過以下 URL 訪問：

- 主頁: http://localhost:82/
- 中文英雄列表: http://localhost:82/zhcn/list_hero
- 繁體中文英雄列表: http://localhost:82/nobu/zhtw/list_hero
- 英文英雄列表: http://localhost:82/en/list_hero
- 日文英雄列表: http://localhost:82/jp/list_hero
- 靜態文件: http://localhost:82/nobu/static/

## 專案結構

```
nobugg_official/
├── app.lua              # 主應用程式 (由 app.moon 編譯)
├── app.moon             # MoonScript 源碼
├── config.lua           # Lapis 配置文件
├── nginx.conf           # Nginx 配置文件
├── models.moon          # 資料模型
├── read_hero.lua        # 英雄資料處理
├── update_redis.lua     # Redis 資料更新
├── langtext.lua         # 多語言文字
├── views/               # 模板文件夾
├── static/              # 靜態資源
├── npc/                 # 遊戲數據文件
└── logs/                # 日誌目錄
```

## 故障排除

### 常見錯誤

1. **模組找不到錯誤**
   ```
   module 'xxx' not found
   ```
   解決方法: 使用 `sudo luarocks install xxx` 安裝對應模組

2. **端口占用錯誤**
   ```
   Address already in use
   ```
   解決方法: 檢查端口 82 是否被占用，或修改 `nginx.conf` 中的端口設定

3. **權限錯誤**
   ```
   Permission denied
   ```
   解決方法: 確保目錄權限正確，或以適當用戶身份運行

### 檢查服務狀態

```bash
# 檢查 OpenResty 進程
ps aux | grep nginx

# 檢查端口監聽
sudo netstat -tulpn | grep :82

# 檢查 Redis 服務
redis-cli ping

# 檢查系統服務日誌
sudo journalctl -u nobugg.service -f
```

## 開發說明

此專案使用以下技術：

- **Lapis**: Lua Web 框架
- **OpenResty**: 高性能 Web 平台
- **Redis**: 記憶體資料庫，用於快取英雄勝率資料
- **etlua**: 模板引擎
- **MoonScript**: 編譯到 Lua 的語言

主要功能：
- 多語言支援（中文簡體/繁體、英文、日文）
- DOTA2 英雄資訊展示
- 裝備資訊展示
- Ban/Pick 相關功能

## 授權

請參考專案中的授權文件。