;; fund-allocation.clar
;; Distributes funds based on approved budgets

(define-map allocations
  { proposal-id: uint }
  { amount: uint, status: (string-ascii 20) }
)

(define-public (allocate-funds (proposal-id uint) (amount uint))
  (let
    (
      (existing-allocation (map-get? allocations { proposal-id: proposal-id }))
    )
    (asserts! (is-none existing-allocation) (err u403))
    (ok (map-set allocations
      { proposal-id: proposal-id }
      { amount: amount, status: "allocated" }
    ))
  )
)

(define-read-only (get-allocation (proposal-id uint))
  (map-get? allocations { proposal-id: proposal-id })
)

