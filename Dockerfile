FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	findutils \
	jq \
	openssl \
	p7zip \
	python \
	rsync \
	tar \
	transmission-cli \
	transmission-daemon \
	unrar \
	unzip && \
 echo "**** install third party themes ****" && \
 mkdir -p /tmp/twttemp && \
 TWTVERSION=$(curl -sX GET "https://api.github.com/repos/iYUYUE/transmission-web-theme/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o \
	/tmp/twt.tar.gz -L \
	"https://github.com/iYUYUE/transmission-web-theme/archive/${TWTVERSION}.tar.gz" && \
 tar xf \
	/tmp/twt.tar.gz -C \
	/tmp/twttemp --strip-components=1 && \
 mv /tmp/twttemp /transmission-web-theme && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*


# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch
