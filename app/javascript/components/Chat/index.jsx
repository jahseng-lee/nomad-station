import React, { useState, useEffect } from "react";
import { createRoot } from "react-dom/client";
import { StreamChat } from 'stream-chat';
import {
  Chat as StreamChatComponent,
  Channel,
  ChannelHeader,
  ChannelList,
  MessageList,
  MessageInput,
  Thread,
  Window,
} from 'stream-chat-react';

const rootElement = document.getElementById("chat-root");
const userId = rootElement?.dataset.streamUserId;
const displayName = rootElement?.dataset.displayName;
const userToken = rootElement?.dataset.streamUserToken;

const filters = { type: 'messaging', members: { $in: [userId]} };
const options = { state: true, presence: true };
const sort = { last_message_at: -1 };

const Chat = () => {
  const [client, setClient] = useState(null);

  useEffect(() => {
    const newClient = new StreamChat('s3u4gjg6hnj2');

    const handleConnectionChange = ({ online = false }) => {
      if (!online) return console.log('connection lost');
      setClient(newClient);
    };

    newClient.on('connection.changed', handleConnectionChange);

    newClient.connectUser(
      {
        id: userId,
        name: displayName,
      },
      userToken,
    );

    return () => {
      newClient.off('connection.changed', handleConnectionChange);
      newClient.disconnectUser().then(() => console.log('connection closed'));
    };
  }, []);

  if (!client) return null;

  return (
    <StreamChatComponent client={client}>
      <ChannelList
        showChannelSearch
        additionalChannelSearchProps={{ searchForChannels: true }}
        filters={filters}
        sort={sort}
        options={options} />
      <Channel>
        <Window>
          <ChannelHeader />
          <MessageList
            messageActions={['edit', 'delete', 'flag', 'mute', 'react', 'reply']}
            />
          <MessageInput focus grow />
        </Window>
        <Thread />
      </Channel>
    </StreamChatComponent>
  );
}

if (rootElement) {
  const root = createRoot(rootElement);
  root.render(<Chat />);
}
