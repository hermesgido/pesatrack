void printInChunks(String message) {
  const chunkSize = 800; // Adjust based on how much the console can handle
  for (var i = 0; i < message.length; i += chunkSize) {
    print(message.substring(i, i + chunkSize > message.length ? message.length : i + chunkSize));
  }
}
