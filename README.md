# WebTools-NG BETA in Docker optimized for Unraid
WebTools-NG (Next Generation) is a stand-alone program designed to help users of Plex Media Server, organise and maintain their media and server.

RESOLUTION: You can also change the resolution from the WebGUI, to do that simply click on 'Show more settings...' (on a resolution change it can occour that the screen is not filled entirely with the Chrome/Electron window, simply restart the container and it will be fullscreen again).

## Env params
| Name | Value | Example |
| --- | --- | --- |
| CUSTOM_RES_W | Enter your preferred screen width | 1280 |
| CUSTOM_RES_H | Enter your preferred screen height | 768 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Umask value | 000 |

## Run example
```
docker run --name WebTools-NG -d \
	-p 8080:8080 \
	--env 'CUSTOM_RES_W=1280' \
	--env 'CUSTOM_RES_H=768' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=000' \
	--volume /mnt/user/appdata/webtools-ng:/mnt/export \
	lnxd/webtools-ng
```
### Webgui address: http://[SERVERIP]:[PORT]/vnc.html?autoconnect=true

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

### Thanks

Please note that 99% of this container was stolen from [ich777's Chromium](https://github.com/ich777/docker-chrome) container, credits for all the good parts go to him. But questions about why things are broken with the integration can go to me. ^^

Please also note that while this container is still a work in progress, so is the [WebTools-NG BETA](https://github.com/WebTools-NG/WebTools-NG). So definitely expect a lot of bugs.