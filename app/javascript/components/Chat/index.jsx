import React from "react";
import { createRoot } from "react-dom/client";

const Chat = () => {
  return (
    <div>
      <h1>TODO</h1>
      <ul>
        <li>intergrate stream.io into the website</li>
        <li>use client library to implement a React component</li>
      </ul>
    </div>
  );
}

const root = createRoot(document.getElementById("chat-root"));
root.render(<Chat />);
