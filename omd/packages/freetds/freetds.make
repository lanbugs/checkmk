FREETDS := freetds
FREETDS_VERS := 0.95.95
FREETDS_DIR := $(FREETDS)-$(FREETDS_VERS)

FREETDS_BUILD := $(BUILD_HELPER_DIR)/$(FREETDS_DIR)-build
FREETDS_UNPACK := $(BUILD_HELPER_DIR)/$(FREETDS_DIR)-unpack
FREETDS_INSTALL := $(BUILD_HELPER_DIR)/$(FREETDS_DIR)-install

#FREETDS_INSTALL_DIR := $(INTERMEDIATE_INSTALL_BASE)/$(FREETDS_DIR)
FREETDS_BUILD_DIR := $(PACKAGE_BUILD_DIR)/$(FREETDS_DIR)
#FREETDS_WORK_DIR := $(PACKAGE_WORK_DIR)/$(FREETDS_DIR)

.PHONY: freetds freetds-install freetds-skel freetds-clean

freetds: $(FREETDS_BUILD)

freetds-install: $(FREETDS_INSTALL)
	
$(FREETDS_BUILD): $(FREETDS_UNPACK)
	cd $(FREETDS_BUILD_DIR) && \
	    ./configure \
		--enable-msdblib \
		--prefix=$(OMD_ROOT) \
		--sysconfdir=/etc/freetds \
		--with-tdsver=7.1 \
		--disable-apps \
		--disable-server \
		--disable-pool \
		--disable-odbc
	$(MAKE) -C $(FREETDS_BUILD_DIR) -j4
# Package python-modules needs some stuff during the build.
	$(MAKE) -C $(FREETDS_BUILD_DIR)/include DESTDIR="" prefix=$(PACKAGE_FREETDS_DESTDIR) install
	$(MAKE) -C $(FREETDS_BUILD_DIR)/src/dblib DESTDIR="" prefix=$(PACKAGE_FREETDS_DESTDIR) install
	$(TOUCH) $@

$(FREETDS_INSTALL): $(FREETDS_BUILD)
# At runtime we need only the libraries.
	$(MAKE) -C $(FREETDS_BUILD_DIR)/src/dblib DESTDIR=$(DESTDIR) install
	$(TOUCH) $@

freetds-skel:

freetds-clean:
	$(RM) -r $(FREETDS_BUILD_DIR) $(BUILD_HELPER_DIR)/$(FREETDS)*
