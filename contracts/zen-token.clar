;; ZEN Token Implementation
(define-fungible-token zen-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-amount (err u101))

;; Token info
(define-data-var token-name (string-ascii 32) "ZenPulse Token")
(define-data-var token-symbol (string-ascii 10) "ZEN")

;; Public functions
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? zen-token amount recipient))
)

(define-public (transfer (amount uint) (recipient principal))
  (ft-transfer? zen-token amount tx-sender recipient)
)

;; Read only functions
(define-read-only (get-name)
  (ok (var-get token-name))
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance zen-token account))
)
