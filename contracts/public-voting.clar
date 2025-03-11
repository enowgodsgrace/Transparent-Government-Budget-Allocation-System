;; public-voting.clar
;; Allows citizens to vote on budget priorities

(define-map votes
  { proposal-id: uint, voter: principal }
  { vote: bool }
)

(define-map vote-counts
  { proposal-id: uint }
  { yes-votes: uint, no-votes: uint }
)

(define-public (cast-vote (proposal-id uint) (vote bool))
  (let
    (
      (existing-vote (map-get? votes { proposal-id: proposal-id, voter: tx-sender }))
      (vote-count (default-to { yes-votes: u0, no-votes: u0 } (map-get? vote-counts { proposal-id: proposal-id })))
    )
    (asserts! (is-none existing-vote) (err u403))
    (map-set votes { proposal-id: proposal-id, voter: tx-sender } { vote: vote })
    (if vote
      (map-set vote-counts { proposal-id: proposal-id }
        (merge vote-count { yes-votes: (+ (get yes-votes vote-count) u1) }))
      (map-set vote-counts { proposal-id: proposal-id }
        (merge vote-count { no-votes: (+ (get no-votes vote-count) u1) }))
    )
    (ok true)
  )
)

(define-read-only (get-vote-count (proposal-id uint))
  (map-get? vote-counts { proposal-id: proposal-id })
)

