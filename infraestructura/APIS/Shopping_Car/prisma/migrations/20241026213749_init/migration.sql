/*
  Warnings:

  - You are about to drop the `ShoppingCartItem` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the column `createdAt` on the `ShoppingCart` table. All the data in the column will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "ShoppingCartItem";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "Order" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "shoppingCartId" INTEGER,
    CONSTRAINT "Order_shoppingCartId_fkey" FOREIGN KEY ("shoppingCartId") REFERENCES "ShoppingCart" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_ShoppingCart" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);
INSERT INTO "new_ShoppingCart" ("id") SELECT "id" FROM "ShoppingCart";
DROP TABLE "ShoppingCart";
ALTER TABLE "new_ShoppingCart" RENAME TO "ShoppingCart";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
