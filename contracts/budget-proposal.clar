;; budget-proposal.clar
;; Manages submission of departmental budget requests

(define-map budget-proposals
  { proposal-id: uint }
  {
    department: (string-ascii 64),
    amount: uint,
    description: (string-ascii 256),
    status: (string-ascii 20)
  }
)

(define-data-var last-proposal-id uint u0)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? budget-proposals { proposal-id: proposal-id })
)

(define-public (submit-proposal (department (string-ascii 64)) (amount uint) (description (string-ascii 256)))
  (let
    (
      (new-proposal-id (+ (var-get last-proposal-id) u1))
    )
    (var-set last-proposal-id new-proposal-id)
    (ok (map-set budget-proposals
      { proposal-id: new-proposal-id }
      {
        department: department,
        amount: amount,
        description: description,
        status: "pending"
      }
    ))
  )
)

(define-public (update-proposal-status (proposal-id uint) (new-status (string-ascii 20)))
  (let
    (
      (proposal (unwrap! (get-proposal proposal-id) (err u404)))
    )
    (ok (map-set budget-proposals
      { proposal-id: proposal-id }
      (merge proposal { status: new-status })
    ))
  )
)

