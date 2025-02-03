;; ZenPulse Main Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-found (err u404))
(define-constant err-already-exists (err u409))

;; Data structures
(define-map user-profiles
  principal
  {
    total-sessions: uint,
    total-minutes: uint,
    last-session: uint,
    mood-rating: uint
  }
)

(define-map meditation-sessions
  uint
  {
    user: principal,
    duration: uint,
    timestamp: uint,
    mood-before: uint,
    mood-after: uint
  }
)

;; Variables
(define-data-var session-counter uint u0)

;; Public functions
(define-public (create-profile)
  (begin
    (asserts! (is-none (map-get? user-profiles tx-sender)) err-already-exists)
    (ok (map-set user-profiles tx-sender {
      total-sessions: u0,
      total-minutes: u0,
      last-session: u0,
      mood-rating: u0
    }))
  )
)

(define-public (log-session (duration uint) (mood-before uint) (mood-after uint))
  (let
    (
      (user-profile (unwrap! (map-get? user-profiles tx-sender) err-not-found))
      (session-id (+ (var-get session-counter) u1))
    )
    (var-set session-counter session-id)
    (map-set meditation-sessions session-id {
      user: tx-sender,
      duration: duration,
      timestamp: block-height,
      mood-before: mood-before,
      mood-after: mood-after
    })
    (map-set user-profiles tx-sender {
      total-sessions: (+ (get total-sessions user-profile) u1),
      total-minutes: (+ (get total-minutes user-profile) duration),
      last-session: block-height,
      mood-rating: mood-after
    })
    (ok session-id)
  )
)

;; Read only functions
(define-read-only (get-profile (user principal))
  (ok (map-get? user-profiles user))
)

(define-read-only (get-session (session-id uint))
  (ok (map-get? meditation-sessions session-id))
)
