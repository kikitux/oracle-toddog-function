#include "toddog.h"
#include "toddog_udp.h"

// to send a metric to ddog
char *metrictoddog(
  OCIExtProcContext *ctx,
  char   *name,	    // pointer to name -- name of the metric
  short  name_i,	  // null status of name
  int    *metric,	  // pointer to metric -- number to be sent to the metric
  short  metric_i,  // null status of metric
  char   *kind,	    // pointer to string1
  short  kind_i,	  // null status of string1
  char   *tag,	    // pointer to string1
  short  tag_i,	    // null status of string1
  short  *ret_i,	  // pointer to indicator null or not null
  short  *ret_l	    // len of return
	)
{
  char *tmp;
  short len;
  char* themetric;  // to store the metric we will send to datadog
  char* thekind;    // to store the kind we will send to datadog

  // Check for null inputs
  if (name_i == OCI_IND_NULL)
  {
    *ret_i = (short)OCI_IND_NULL;

    // PL/SQL has no notion of a NULL ptr, so return a zero-byte string.
    tmp = OCIExtProcAllocCallMemory(ctx, 1);
    tmp[0] = '\0';

    return(tmp);
  }

  // the main part 

  if  (kind_i == OCI_IND_NOTNULL)
  {
    asprintf(&thekind,"%s",kind);
  } else {
    asprintf(&thekind,"%s","g");  // no kind, we default to gauge
  }

  if  (tag_i == OCI_IND_NOTNULL)
  {
    asprintf(&themetric,"%s:%d|%s|#%s",name, metric, thekind,tag);
  } else {
    asprintf(&themetric,"%s:%d|%s|",name, metric, thekind);
  }

  udp(8125, themetric);         // we fire the metric to datadog

  // the reply part
  char *reply = "done";         // as udp is stateless, we assume all went fine

  // Allocate memory for result string, including NULL terminator.
  len = strlen(reply);
  tmp = OCIExtProcAllocCallMemory(ctx, len + 1);
  tmp[0] = '\0';

  // set the reply
  strcat(tmp, reply);

  // Set ret indicator and length.
  *ret_i = (short)OCI_IND_NOTNULL;
  *ret_l = len;

  // Return pointer, which PL/SQL frees later.
  return tmp;
}


char *eventtoddog(
  OCIExtProcContext *ctx,
  char   *title,            // pointer to name -- name of the metric
  short  title_i,         // null status of name
  char    *text,          // pointer to metric -- number to be sent to the metric
  short  text_i,  // null status of metric
  char   *tag,      // pointer to string1
  short  tag_i,     // null status of string1
  short  *ret_i,          // pointer to indicator null or not null
  short  *ret_l     // len of return
        )
{
  char *tmp;
  short len;
  char* theevent;

  // Check for null inputs
  if ( (title_i == OCI_IND_NULL) || (text_i == OCI_IND_NULL) )
  {
    *ret_i = (short)OCI_IND_NULL;

    // PL/SQL has no notion of a NULL ptr, so return a zero-byte string.
    tmp = OCIExtProcAllocCallMemory(ctx, 1);
    tmp[0] = '\0';

    return(tmp);
  }

  // the main part 

  asprintf(&theevent,"_e{%d,%d}:%s|%s|#%s",strlen(title),strlen(text),title,text,tag);

  udp(8125, theevent);

  // the reply part
  char *reply = "done";         // as udp is stateless, we assume all went fine

  // Allocate memory for result string, including NULL terminator.
  len = strlen(reply);
  tmp = OCIExtProcAllocCallMemory(ctx, len + 1);
  tmp[0] = '\0';

  // set the reply
  strcat(tmp, reply);

  // Set ret indicator and length.
  *ret_i = (short)OCI_IND_NOTNULL;
  *ret_l = len;

  // Return pointer, which PL/SQL frees later.
  return tmp;
}
