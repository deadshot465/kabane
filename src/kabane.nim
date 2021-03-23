import dimscord, asyncdispatch, times, options, dotenv, os

let env = initDotEnv()
env.load()
let token = os.getEnv("TOKEN")
let prefix = "ka?"
let client = newDiscordClient(token)

proc onReady(shard: Shard, ready: Ready) {.event(client).} =
  echo "Ready as " & $ready.user
  await shard.updateStatus(activity = some ActivityStatus(
    name: "Pizza",
    kind: atPlaying
  ), status = "online")

proc messageCreate(shard: Shard, message: Message) {.event(client).} = 
  if message.author.bot: return
  if message.content == prefix & "ping":
    let
      before = epochTime() * 1000
      msg = await client.api.sendMessage(message.channel_id, "🏓 Pinging...")
      after = epochTime() * 1000
    discard await client.api.editMessage(
      message.channel_id,
      msg.id,
      "🏓 Pong!\nLatency is: " & $int(after - before) & "ms. Shard latency is: " & $shard.latency() & "ms."
    )
  elif message.content == prefix & "about":
    discard await client.api.sendMessage(
      message.channel_id,
      embed = some Embed(
        author: some EmbedAuthor(
          name: some "Kabane from Kemono Jihen",
          icon_url: some "https://cdn.discordapp.com/avatars/823391183035170816/c6deb16aa863aae3ad640e654380bbcd.webp?size=1024"
        ),
        description: some "Kabane in the Land of Cute Bois.\nKabane was inspired by the anime/manga Kemono Jihen.\nKabane version 0.1 was made and developed by:\n**Tetsuki Syu#1250, Kirito#9286**\nWritten with:\n[Nim](https://nim-lang.org/) and [Dimscord](https://github.com/krisppurg/dimscord) library.",
        color: some 0x7c1a31,
        thumbnail: some EmbedThumbnail(
          url: some "https://cdn.discordapp.com/attachments/811517007446671391/814955454031069224/Nim-logo.png"
        ),
        footer: some EmbedFooter(
          text: "Kabane Bot: Release 0.1 | 2021-03-24"
        )
      )
    )

when isMainModule:
  waitFor client.startSession()
