import Fastify from "fastify";

(async () => {
  console.log("Starting");

  const fastify = Fastify({
    logger: true,
  });

  // Declare a route
  fastify.get("/", async function handler(request, reply) {
    return "Fastify + Bun!";
  });

  fastify.get("/ping", async function handler(request, reply) {
    return "Pong!";
  });

  // Run the server!
  try {
    await fastify.listen({
      port: 3000,
      host: "0.0.0.0",
    });
  } catch (err) {
    fastify.log.error(err);
    console.error(err);
    process.exit(1);
  }
})();
