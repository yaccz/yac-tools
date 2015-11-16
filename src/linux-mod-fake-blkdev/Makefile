unamer ?= $(shell uname -r)
obj-m += fake-blkdev.o

all:
	make -C /lib/modules/$(unamer)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(unamer)/build M=$(PWD) clean
