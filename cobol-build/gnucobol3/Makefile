STAMP := latest/download.stamp

download:
	if [ -e $(STAMP) ] && [ "$(GNUCOBOL_SRC)" = "$(shell cat $(STAMP))" ] ; then \
		echo "cached GNUcobol is up-to-date"; \
	else \
		rm -rf latest; \
	fi
	if [ ! -d latest ]; then \
		echo "downloading fresh GNUcobol"; \
		mkdir latest; \
		wget -O- $(GNUCOBOL_SRC) | tar -xJ -C latest --strip-components=1; \
		echo "$(GNUCOBOL_SRC)" > $(STAMP); \
	fi

install: latest/config.h
	make -C latest install
	ldconfig

latest/config.h: latest/config.h.in
	cd latest && ./configure
