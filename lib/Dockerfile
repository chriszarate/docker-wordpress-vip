FROM alpine

RUN apk add --no-cache subversion

RUN svn co --quiet --trust-server-cert --non-interactive https://vip-svn.wordpress.com/plugins /usr/local/src/vip-plugins

RUN svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/jetpack/trunk /usr/local/src/wordpress-plugins/jetpack

RUN svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/log-deprecated-notices/trunk /usr/local/src/wordpress-plugins/log-deprecated-notices

RUN svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/monster-widget/trunk /usr/local/src/wordpress-plugins/monster-widget

RUN svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/query-monitor/trunk /usr/local/src/wordpress-plugins/query-monitor

RUN svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/rewrite-rules-inspector/trunk /usr/local/src/wordpress-plugins/rewrite-rules-inspector

RUN svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/user-switching/trunk /usr/local/src/wordpress-plugins/user-switching

RUN svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/vip-scanner/trunk /usr/local/src/wordpress-plugins/vip-scanner

RUN svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/wordpress-importer/trunk /usr/local/src/wordpress-plugins/wordpress-importer

CMD /bin/true
