obj-m += avl/
obj-m += icp/
obj-m += lua/
obj-m += nvpair/
obj-m += spl/
obj-m += unicode/
obj-m += zcommon/
obj-m += zfs/

INSTALL_MOD_DIR ?= extra

ZFS_MODULE_CFLAGS += -std=gnu99 -Wno-declaration-after-statement
ZFS_MODULE_CFLAGS += 
ZFS_MODULE_CFLAGS += -include /usr/src/zfs-0.8.3/zfs_config.h
ZFS_MODULE_CFLAGS += -I/usr/src/zfs-0.8.3/include/spl
ZFS_MODULE_CFLAGS += -I/usr/src/zfs-0.8.3/include

ZFS_MODULE_CPPFLAGS += -D_KERNEL
ZFS_MODULE_CPPFLAGS += -UDEBUG -DNDEBUG

#ZFS_MODULE_CFLAGS += -I/include
#KBUILD_EXTRA_SYMBOLS += 

export ZFS_MODULE_CFLAGS ZFS_MODULE_CPPFLAGS

SUBDIR_TARGETS = icp lua

modules:
	list='$(SUBDIR_TARGETS)'; for targetdir in $$list; do \
		$(MAKE) -C $$targetdir; \
	done
	$(MAKE) -C /usr/src/linux M=`pwd`  CONFIG_ZFS=m $@

clean:
	@# Only cleanup the kernel build directories when CONFIG_KERNEL
	@# is defined.  This indicates that kernel modules should be built.
#	$(MAKE) -C /usr/src/linux M=`pwd`  $@

	if [ -f NONE ]; then $(RM) NONE; fi
	if [ -f Module.markers ]; then $(RM) Module.markers; fi

	find . -name '*.ur-safe' -type f -print | xargs $(RM)

modules_install:
	@# Install the kernel modules
	$(MAKE) -C /usr/src/linux M=`pwd` $@ \
		INSTALL_MOD_PATH=$(DESTDIR)$(INSTALL_MOD_PATH) \
		INSTALL_MOD_DIR=$(INSTALL_MOD_DIR) \
		KERNELRELEASE=5.4.17-rt-jsX
	@# Remove extraneous build products when packaging
	kmoddir=$(DESTDIR)$(INSTALL_MOD_PATH)/lib/modules/5.4.17-rt-jsX; \
	if [ -n "$(DESTDIR)" ]; then \
		find $$kmoddir -name 'modules.*' | xargs $(RM); \
	fi
	sysmap=$(DESTDIR)$(INSTALL_MOD_PATH)/boot/System.map-5.4.17-rt-jsX; \
	if [ -f $$sysmap ]; then \
		depmod -ae -F $$sysmap 5.4.17-rt-jsX; \
	fi

modules_uninstall:
	@# Uninstall the kernel modules
	kmoddir=$(DESTDIR)$(INSTALL_MOD_PATH)/lib/modules/5.4.17-rt-jsX
	list='$(obj-m)'; for objdir in $$list; do \
		$(RM) -R $$kmoddir/$(INSTALL_MOD_DIR)/$$objdir; \
	done

distdir:
	list='$(obj-m)'; for objdir in $$list; do \
		(cd ../module && find $$objdir \
		-name '*.c' -o -name '*.h' -o -name '*.S' | \
		xargs -r cp --parents -t /usr/src/zfs-0.8.3/module/$$distdir); \
	done

distclean maintainer-clean: clean
install: modules_install
uninstall: modules_uninstall
all: modules
check:
