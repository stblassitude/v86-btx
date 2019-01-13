#!/usr/bin/env python3

import aiohttp
import asyncio

from aiohttp import web

routes = web.RouteTableDef()

# @routes.get('/')
# async def hello(request):
#     return web.Response(text="Hello, world")


@routes.get('/btxws')
async def websocket_handler(request):

    ws = web.WebSocketResponse()
    await ws.prepare(request)
    reader, writer = await asyncio.open_connection(
        'belgradstr.dyndns.org', 20001)
    print("*** connection open")

    async def server_to_websocket():
        while True:
            data = await reader.read(64)
            print(f'*** server sent {len(data)}')
            await ws.send_bytes(data)

    asyncio.get_event_loop().create_task(server_to_websocket())

    async for msg in ws:
        if msg.type == aiohttp.WSMsgType.BINARY:
            # print(f'### {msg.data}')
            print(f'*** browser sent {len(msg.data)}')
            writer.write(msg.data)
            # await ws.send_str(msg.data)
        elif msg.type == aiohttp.WSMsgType.ERROR:
            print('ws connection closed with exception %s' %
                  ws.exception())

    writer.close()
    print('websocket connection closed')

    return ws

app = web.Application()

app.add_routes([web.static('/files', 'web/', show_index=True)])
app.add_routes(routes)

web.run_app(app)