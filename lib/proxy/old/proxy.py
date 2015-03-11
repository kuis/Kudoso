# mitmdump -p 8080 -s proxy.py

import re

def valid_url(match_url):
  urls = ['www.digg.com', 'www.netflix.com', 'www.zeebly.com']

  for url in urls:
    if re.search(url, match_url):
      return True

  return False

# def clientconnect(ctx, client_connect):
#   print "CLIENT CONNECT"
#   print client_connect.address
#
def request(context, flow):
  print "Connect ip"
  print flow.request.client_conn.address

  try:
    referer = flow.request.headers['referer']
    if not (valid_url(flow.request.host) or (referer and valid_url(referer))):
      # print "REDIRECT"
      # flow.request.host = 'www.zeebly.com'

      f = ctx.duplicate_flow(flow)
      f.request.host = "www.zeebly.com"
      ctx.replay_request(f)

    # else:
      # print "DONT REDIRECT"
  except Exception as inst:
    print "ERROR:"
    print inst

  return ctx

  # context.hostname = flow.request.host
  # flow.request.host = 'www.zeebly.com'
  # print "headers-----------"
  # print flow.request.headers
  # print "end------------"
  # flow.request.host = 'www.google.com'
  # flow.response.content = 'testing'
  # f = ctx.duplicate_flow(flow)
  # f.request.path = "/changed"
  # f.request.host = 'www.google.com'
  # ctx.replay_request(f)

# def response(context, flow):
  # print "RESPONSE2: {0}".format(flow.response.code)
  # flow.request.host = context.hostname
  # if flow.response.headers["content-type"] == ["image/png"]:
  # print flow.response.headers["content-type"]
  # flow.request.host = 'www.digg.com'
  # flow.response.content = "REPLACED CONTENT"
  # flow.response.content