// server.js
require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const path = require('path');
const bcrypt = require('bcrypt');
const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '../')));

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

// Маршрут для получения всех товаров
app.get('/api/products', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM products');
        res.json(result.rows);
    } catch (err) {
        console.error('Ошибка при запросе товаров', err);
        res.status(500).json({ error: 'Ошибка при получении данных' });
    }
});

// Маршрут для добавления нового товара
app.post('/api/products', async (req, res) => {
    const { name, price, image_url, category } = req.body;
    if (!name || !price || !category) {
        return res.status(400).json({ error: 'Необходимо указать название, цену и категорию товара' });
    }
    try {
        const result = await pool.query(
            'INSERT INTO products (name, price, image_url, category) VALUES ($1, $2, $3, $4) RETURNING *',
            [name, price, image_url, category]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error('Ошибка при добавлении товара', err);
        res.status(500).json({ error: 'Ошибка при добавлении товара' });
    }
});

// Маршрут для регистрации нового пользователя
app.post('/api/register', async (req, res) => {
    const { username, email, password } = req.body;
    if (!username || !email || !password) {
        return res.status(400).json({ error: 'Необходимо указать имя пользователя, email и пароль' });
    }
    try{
    const hashedPassword = await bcrypt.hash(password, 10);

    const result = await pool.query(
        'INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING *',
        [username, email, hashedPassword]
    );

    res.status(201).json({ message: 'Пользователь успешно зарегистрирован', user: result.rows[0] });

    }catch (err) {
        console.error('Ошибка при регистрации пользователя', err);
         if (err.code === '23505') {
            return res.status(409).json({ error: 'Пользователь с таким именем или email уже существует' });
        }
        res.status(500).json({ error: 'Ошибка при регистрации пользователя' });
    }
});
// Маршрут для входа пользователя
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
     if (!email || !password) {
        return res.status(400).json({ error: 'Необходимо указать email и пароль' });
    }

    try {
        const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
         if (result.rows.length === 0) {
            return res.status(401).json({ error: 'Неверный email или пароль' });
        }
        const user = result.rows[0];
         const passwordMatch = await bcrypt.compare(password, user.password);
         if (!passwordMatch) {
           return res.status(401).json({ error: 'Неверный email или пароль' });
        }
       
        res.json({ message: 'Вход успешно выполнен', user: {id:user.id, username:user.username, email: user.email } });
    } catch (err) {
        console.error('Ошибка при входе пользователя', err);
        res.status(500).json({ error: 'Ошибка при входе пользователя' });
    }
});

// Route to add product to cart
app.post('/api/cart/add', async (req, res) => {
    const { userId, productId } = req.body;
    if (!userId || !productId) {
        return res.status(400).json({ error: 'User ID and Product ID are required' });
    }

    try {
        const result = await pool.query(
          'INSERT INTO cart_items (user_id, product_id) VALUES ($1, $2) RETURNING *',
          [userId, productId]
         );
        res.status(201).json({ message: 'Product added to cart successfully', cartItem: result.rows[0] });
    } catch (err) {
        console.error('Error adding product to cart', err);
         res.status(500).json({ error: 'Error adding product to cart' });
    }
});

// Route to get all cart items for a user
app.get('/api/cart/:userId', async (req, res) => {
    const userId = req.params.userId;

    try {
        const result = await pool.query(
            `SELECT cart_items.id, products.name, products.price, products.image_url
             FROM cart_items
             INNER JOIN products ON cart_items.product_id = products.id
             WHERE cart_items.user_id = $1`,
            [userId]
        );
        res.json(result.rows);
    } catch (err) {
         console.error('Error fetching cart items', err);
        res.status(500).json({ error: 'Error fetching cart items' });
    }
});

app.delete('/api/cart/remove/:itemId', async (req, res) => {
  const itemId = req.params.itemId;

    try {
    const result = await pool.query('DELETE FROM cart_items WHERE id = $1 RETURNING *', [itemId]);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Cart item not found' });
    }

      res.json({ message: 'Cart item removed successfully', cartItem: result.rows[0] });
  } catch (err) {
    console.error('Error removing cart item', err);
    res.status(500).json({ error: 'Error removing cart item' });
  }
});

// Route to create a new order (checkout)
app.post('/api/orders/create', async (req, res) => {
    const { userId } = req.body;
     if (!userId) {
        return res.status(400).json({ error: 'User ID required' });
    }
    try {
        // 1. Get cart items
          const cartItemsResult = await pool.query(
            `SELECT cart_items.id, products.id as product_id, products.price
             FROM cart_items
             INNER JOIN products ON cart_items.product_id = products.id
             WHERE cart_items.user_id = $1`,
            [userId]
          );

          const cartItems = cartItemsResult.rows;

        if (cartItems.length === 0) {
          return res.status(400).json({ error: 'Cart is empty' });
        }

        // 2. Calculate total amount
           const totalAmount = cartItems.reduce((sum, item) => sum + parseFloat(item.price), 0);

        // 3. Create order
        const orderResult = await pool.query(
            'INSERT INTO orders (user_id, total_amount) VALUES ($1, $2) RETURNING id',
            [userId, totalAmount]
        );
       const orderId = orderResult.rows[0].id;

        // 4. Create order items
         for (const item of cartItems) {
             await pool.query(
                'INSERT INTO order_items (order_id, product_id, unit_price) VALUES ($1, $2, $3)',
                  [orderId, item.product_id, item.price]
              );
        }
         // 5. Remove items from cart
        await pool.query('DELETE FROM cart_items WHERE user_id = $1', [userId]);

        res.status(201).json({ message: 'Order created successfully', orderId: orderId});
    } catch (err) {
        console.error('Error creating order', err);
        res.status(500).json({ error: 'Error creating order' });
    }
});
// Route to get all orders for a user
app.get('/api/orders/:userId', async (req, res) => {
  const userId = req.params.userId;

  try {
      const ordersResult = await pool.query(
          `SELECT orders.id, orders.order_date, orders.total_amount, orders.status
           FROM orders
           WHERE orders.user_id = $1
           ORDER BY orders.order_date DESC`,
           [userId]
        );
     const orders = ordersResult.rows
        for(const order of orders){
                const orderItemsResult = await pool.query(
              `SELECT order_items.id, products.name, products.price, products.image_url, order_items.quantity
                   FROM order_items
                    INNER JOIN products ON order_items.product_id = products.id
                  WHERE order_items.order_id = $1`,
              [order.id]
              );
               order.items = orderItemsResult.rows;
        }


      res.json(orders);
  } catch (err) {
      console.error('Error fetching orders', err);
      res.status(500).json({ error: 'Error fetching orders' });
    }
  });

  app.put('/api/users/update', async (req, res) => {
    const { id, username, email, password } = req.body;
      if (!id ) {
          return res.status(400).json({ error: 'Необходимо указать id пользователя' });
        }
    try {
         let updateQuery = 'UPDATE users SET ';
         const queryParams = [];
          let paramIndex = 1;

         if(username) {
            updateQuery += `username = $${paramIndex}, `;
             queryParams.push(username);
            paramIndex++;
          }
          if(email) {
              updateQuery += `email = $${paramIndex}, `;
             queryParams.push(email);
             paramIndex++;
           }


        if(password) {
            const hashedPassword = await bcrypt.hash(password, 10);
             updateQuery += `password = $${paramIndex}, `;
             queryParams.push(hashedPassword);
            paramIndex++;
        }

        updateQuery = updateQuery.slice(0, -2); // Remove trailing comma and space
        updateQuery += ` WHERE id = $${paramIndex} RETURNING *`;
        queryParams.push(id);
      
        const result = await pool.query(updateQuery, queryParams);
        if (result.rows.length === 0) {
          return res.status(404).json({ error: 'Пользователь не найден' });
        }

        res.json({ message: 'Данные пользователя успешно обновлены', user: result.rows[0] });
    } catch (err) {
        console.error('Ошибка при обновлении данных пользователя', err);
          if (err.code === '23505') {
               return res.status(409).json({ error: 'Пользователь с таким именем или email уже существует' });
           }
        res.status(500).json({ error: 'Ошибка при обновлении данных пользователя' });
    }
});

app.listen(PORT, () => {
    console.log(`Сервер запущен на порту ${PORT}`);
});