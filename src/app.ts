import express, { Request, Response } from 'express';
import bodyParser from 'body-parser';

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/health', (req: Request, res: Response) => {
  res.status(200).send('OK');
});

export default app;
