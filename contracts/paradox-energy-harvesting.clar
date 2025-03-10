;; Paradox Energy Harvesting Contract
;; Harvests energy from temporal paradoxes

(define-map energy-harvesters
  { id: uint }
  {
    owner: principal,
    location: (string-ascii 100),
    energy-harvested: uint,
    last-harvest: uint
  }
)

(define-data-var next-harvester-id uint u1)

(define-public (register-harvester (location (string-ascii 100)))
  (let ((harvester-id (var-get next-harvester-id)))
    (map-set energy-harvesters
      { id: harvester-id }
      {
        owner: tx-sender,
        location: location,
        energy-harvested: u0,
        last-harvest: block-height
      }
    )
    (var-set next-harvester-id (+ harvester-id u1))
    (ok harvester-id)
  )
)

(define-public (harvest-energy (harvester-id uint) (amount uint))
  (let ((harvester (default-to { owner: tx-sender, location: "", energy-harvested: u0, last-harvest: u0 }
                              (map-get? energy-harvesters { id: harvester-id }))))
    (map-set energy-harvesters
      { id: harvester-id }
      {
        owner: (get owner harvester),
        location: (get location harvester),
        energy-harvested: (+ (get energy-harvested harvester) amount),
        last-harvest: block-height
      }
    )
    (ok amount)
  )
)

(define-read-only (get-harvester (harvester-id uint))
  (map-get? energy-harvesters { id: harvester-id })
)

