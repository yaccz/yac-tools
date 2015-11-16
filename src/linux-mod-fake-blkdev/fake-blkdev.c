#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>

int MAJOR = 253;
char* NAME = "fake-blkdev";

int init_module(void)
{
    int ret;

    ret = register_blkdev(MAJOR, NAME);
    if ( ret < 0 ) {
        printk(KERN_INFO "fake-blkdev: register_blkdev failed\n");
        return 1;
    }

    printk(KERN_INFO "fake-blkdev: major=%d name=%s\n", MAJOR, NAME);
    printk(KERN_INFO "fake-blkdev: initialized\n");
    return 0;
}

void cleanup_module(void)
{
    unregister_blkdev(MAJOR, NAME);
    printk(KERN_INFO "fake-blkdev: cleaned up\n");
}
