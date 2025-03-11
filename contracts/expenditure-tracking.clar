;; expenditure-tracking.clar
;; Monitors and reports on actual spending

(define-map expenditures
  { proposal-id: uint }
  { spent: uint, last-updated: uint }
)

(define-public (record-expenditure (proposal-id uint) (amount uint))
  (let
    (
      (existing-expenditure (default-to { spent: u0, last-updated: u0 }
        (map-get? expenditures { proposal-id: proposal-id })))
    )
    (ok (map-set expenditures
      { proposal-id: proposal-id }
      {
        spent: (+ (get spent existing-expenditure) amount),
        last-updated: block-height
      }
    ))
  )
)

(define-read-only (get-expenditure (proposal-id uint))
  (map-get? expenditures { proposal-id: proposal-id })
)

