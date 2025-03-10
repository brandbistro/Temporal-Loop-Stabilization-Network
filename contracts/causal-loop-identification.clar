;; Causal Loop Identification Contract
;; Identifies and tracks causal loops in time

(define-map causal-loops
  { id: uint }
  {
    description: (string-ascii 100),
    severity: uint,
    status: (string-ascii 20)
  }
)

(define-data-var next-loop-id uint u1)

(define-public (register-loop (description (string-ascii 100)) (severity uint))
  (let ((loop-id (var-get next-loop-id)))
    (map-set causal-loops
      { id: loop-id }
      {
        description: description,
        severity: severity,
        status: "identified"
      }
    )
    (var-set next-loop-id (+ loop-id u1))
    (ok loop-id)
  )
)

(define-public (update-loop-status (loop-id uint) (new-status (string-ascii 20)))
  (let ((loop (default-to { description: "", severity: u0, status: "" }
                         (map-get? causal-loops { id: loop-id }))))
    (map-set causal-loops
      { id: loop-id }
      (merge loop { status: new-status })
    )
    (ok true)
  )
)

(define-read-only (get-loop (loop-id uint))
  (map-get? causal-loops { id: loop-id })
)

