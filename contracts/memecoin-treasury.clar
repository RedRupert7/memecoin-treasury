
;; memecoin-treasury.clar

;; Import the sBTC trait
(use-trait sbtc-trait .sbtc-token.sbtc-trait)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-amount (err u101))
(define-constant err-invalid-schedule (err u102))
(define-constant err-funds-locked (err u103))

;; Data storage
(define-data-var treasury-balance uint u0)
(define-data-var release-schedule (list 10 {amount: uint, block-height: uint}) (list))
(define-data-var last-withdrawal uint u0)

;; Public functions

;; Set the release schedule (only callable by the contract owner)
(define-public (set-release-schedule (schedule (list 10 {amount: uint, block-height: uint})))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (> (len schedule) u0) err-invalid-schedule)
        (ok (var-set release-schedule schedule))
    )
)

;; Deposit sBTC into the treasury
(define-public (deposit-sbtc (sbtc-token <sbtc-trait>) (amount uint))
    (begin
        (asserts! (> amount u0) err-invalid-amount)
        (try! (contract-call? sbtc-token transfer amount tx-sender (as-contract tx-sender)))
        (var-set treasury-balance (+ (var-get treasury-balance) amount))
        (ok true)
    )
)

;; Withdraw sBTC from the treasury (only callable by the contract owner)
(define-public (withdraw-sbtc (sbtc-token <sbtc-trait>))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (let ((withdrawable (calculate-withdrawable)))
            (asserts! (> withdrawable u0) err-funds-locked)
            (try! (contract-call? sbtc-token transfer withdrawable (as-contract tx-sender) tx-sender))
            (var-set treasury-balance (- (var-get treasury-balance) withdrawable))
            (var-set last-withdrawal block-height)
            (ok true)
        )
    )
)

;; Helper functions

;; Calculate the withdrawable amount based on the release schedule
(define-private (calculate-withdrawable)
    (fold + u0 
        (map get amount 
            (filter is-withdrawable (var-get release-schedule))))
)

;; Check if a schedule entry is withdrawable
(define-private (is-withdrawable (entry {amount: uint, block-height: uint}))
    (and 
        (>= block-height (get block-height entry))
        (> (get amount entry) u0)
    )
)