#!/bin/bash
export DISPLAY=:99
export XAUTHORITY=${DATA_DIR}/.Xauthority

echo "---Resolution check---"
if [ -z "${CUSTOM_RES_W}" ]; then
	CUSTOM_RES_W=1024
fi
if [ -z "${CUSTOM_RES_H}" ]; then
	CUSTOM_RES_H=768
fi

if [ "${CUSTOM_RES_W}" -le 1023 ]; then
	echo "---Width to low must be a minimal of 1024 pixels, correcting to 1024...---"
	CUSTOM_RES_W=1024
fi
if [ "${CUSTOM_RES_H}" -le 767 ]; then
	echo "---Height to low must be a minimal of 768 pixels, correcting to 768...---"
	CUSTOM_RES_H=768
fi
echo "---Checking for old logfiles---"
find $DATA_DIR -name "XvfbLog.*" -exec rm -f {} \;
find $DATA_DIR -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old display lock files---"
rm -rf /tmp/.X99*
rm -rf /tmp/.X11*
rm -rf ${DATA_DIR}/.vnc/*.log ${DATA_DIR}/.vnc/*.pid ${DATA_DIR}/Singleton*
chmod -R ${DATA_PERM} ${DATA_DIR}
if [ -f ${DATA_DIR}/.vnc/passwd ]; then
	chmod 600 ${DATA_DIR}/.vnc/passwd
fi
screen -wipe 2 &>/dev/null

echo "---Starting TurboVNC server---"
vncserver -geometry ${CUSTOM_RES_W}x${CUSTOM_RES_H} -depth ${CUSTOM_DEPTH} :99 -rfbport ${RFB_PORT} -noxstartup ${TURBOVNC_PARAMS} 2>/dev/null
sleep 2
echo "---Starting Fluxbox---"
screen -d -m env HOME=/etc /usr/bin/fluxbox
sleep 2
echo "---Starting noVNC server---"
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem ${NOVNC_PORT} localhost:${RFB_PORT}
sleep 2

cd /home/docker
if [ ! -d /home/docker/squashfs-root ]; then
	echo "---Installing WebTools-NG---"
	wget -q "https://github.com/WebTools-NG/WebTools-NG/releases/download/V0.3.12.898c1ee/WebTools-NG-0.3.12.898c1ee.AppImage"
	chmod +x WebTools-NG-0.3.12.898c1ee.AppImage
	# Extract AppImage to remove need for Fuse
	./WebTools-NG-0.3.12.898c1ee.AppImage --appimage-extract >/dev/null
	mv squashfs-root webtools-ng
	rm WebTools-NG-0.3.12.898c1ee.AppImage
fi

if [ ! -f /home/docker/.config/WebTools-NG/WebTools-NG.json ]; then
	echo "---Adding default options to WebTools-NG config---"
	cat >/home/docker/.config/WebTools-NG/WebTools-NG.json <<EOL
{
	"General": {
		"ExportPath": "/mnt/export"
}
EOL
fi

echo "---Starting WebTools-NG---"
cd webtools-ng
./webtools-ng --no-sandbox X-Plex-Token=${PLEX_TOKEN} ExportPath=${EXPORT_PATH} >/dev/null
