#include <linux/module.h>
#include <linux/kernel.h>

int init_module(void)
{
    printk(KERN_INFO "fake-blkdev initialized\n");
    return 0;
}

void cleanup_module(void)
{
    printk(KERN_INFO "fake-blkdev cleaned up\n");
}
