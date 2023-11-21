In this PR, I am creating the order management functionality. This includes the creation of two new tables, `orders` and `payments`, where we will handle payment transactions.

We have the new schema within a context called `order_manager`, and we have the module that will handle our business logic called `orders_manager`. In `orders_manager`, we have the requested methods for the new functionality.

The operation `apply_payment_to_order` is the only one involved in a transaction to minimize race conditions as much as possible. This way, the database is responsible for serializing and preventing such issues.

To see and test into playground, after run the `mix phx.server` check

`[localhost](http://localhost:4000/api/graphiql)`
