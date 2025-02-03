import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can create new user profile",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let wallet1 = accounts.get("wallet_1")!;
    let block = chain.mineBlock([
      Tx.contractCall("zen-pulse", "create-profile", [], wallet1.address)
    ]);
    assertEquals(block.receipts[0].result, '(ok true)');
  },
});

Clarinet.test({
  name: "Can log meditation session",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let wallet1 = accounts.get("wallet_1")!;
    let block = chain.mineBlock([
      Tx.contractCall("zen-pulse", "create-profile", [], wallet1.address),
      Tx.contractCall("zen-pulse", "log-session", [
        types.uint(30), // duration
        types.uint(3),  // mood before
        types.uint(8)   // mood after
      ], wallet1.address)
    ]);
    assertEquals(block.receipts[1].result, '(ok u1)');
  },
});
