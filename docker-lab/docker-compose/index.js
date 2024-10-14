const express = require('express');
const redis = require('redis');

const app = express();
const port = process.env.PORT || 3000;

// Conectar ao Redis
const client = redis.createClient({
    url: 'redis://redis-server:6379'
})

client.on('error', (err) => console.error('Redis Client Error', err));

// Rota para incrementar o contador
app.get('/contador', async (req, res) => {
    try {
        await client.connect();
        // Incrementa o valor da chave 'contador'
        await client.incr('contador');
        const contador = await client.get('contador');
        const msg = `O contador está em: ${contador}`;
        res.send(msg);
        console.log(msg);
        await client.disconnect();
    } catch (error) {
        console.error(error);
        res.status(500).send('Erro ao incrementar o contador');
    }
});

app.listen(port, () => {
    console.log(`Servidor ouvindo na porta ${port}`);
});