#include "toddog_udp.h"

void udp(const unsigned short port, char* message)
{
  struct sockaddr_in oAddr;
  socklen_t iAddrLen = sizeof(oAddr);
  int sock;

  memset((char *)&oAddr, 0,sizeof(oAddr));
  oAddr.sin_family      = AF_INET;
  oAddr.sin_port        = htons(port);
  oAddr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);   // set the address for localhost
  if((sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1){
    return;
  }
  sendto(sock, message, strlen(message) + 1, MSG_CONFIRM, (struct sockaddr *)&oAddr, iAddrLen);
  return;
}
