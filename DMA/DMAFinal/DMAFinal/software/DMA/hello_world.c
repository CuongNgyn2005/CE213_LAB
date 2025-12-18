#define DMA (int *) 0x23020
#include "io.h"
#include "stdio.h"
#include "system.h"

int length = 32;
int control = 8;
int readLength = 20;
int enable = 1;

char pdata0[32] = {0, 1, 2, 3, 4, 5, 6, 7,
					8, 9, 10, 11, 12, 13, 14, 15,
					16, 17, 18, 19, 20, 21, 22, 23,
					24, 25, 26, 27, 28, 29, 30, 31};
char *pdata1 = (char*) (ONCHIP_MEMORY2_1_BASE);


void handlerStatus()
{
	int i;
	for (i = 0; i < 32; i++)
	{
		printf("Byte %d = %d \n", i, pdata1[i]);
	}
}
int main()
{
	char *a = pdata0;
	char *b = pdata1;
	IOWR_32DIRECT(DMA,0*4, (int)pdata0 );
	IOWR_32DIRECT(DMA, 1*4, (int)pdata1 );
	IOWR_32DIRECT(DMA, 2*4, length);
	IOWR_32DIRECT(DMA, 3*4, control);
	//Xu ly dung polling de kiem tra hoan thanh DMA
	//co do tre 24 chu ky xung clock voi clock dau vao la 50MHz
	//Co the toi uu hon khi tuy chinh lai code C de tao ra iread nhanh hon hoac xu dung interrupt
	while(enable)
	{
		if((IORD_32DIRECT(DMA, 7*4)) <= 2){
			enable = 0;
			handlerStatus();
		}
	}

	return 0;
}

