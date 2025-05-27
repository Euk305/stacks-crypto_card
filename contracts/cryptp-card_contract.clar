
;; cryptp-card_contract
;; NFT functionality for crypto cards with attributes and rarity system

;; constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-not-authorized (err u103))
(define-constant err-invalid-rarity (err u106))

;; rarity tiers
(define-constant rarity-common u1)
(define-constant rarity-uncommon u2)
(define-constant rarity-rare u3)
(define-constant rarity-epic u4)
(define-constant rarity-legendary u5)
(define-constant rarity-mythic u6)

;; data maps and vars
(define-non-fungible-token crypto-card uint)

(define-map card-details uint 
  {
    name: (string-ascii 64),
    description: (string-ascii 256),
    image-uri: (string-utf8 256),
    rarity: uint,
    attributes: (list 10 {trait: (string-ascii 32), value: (string-ascii 32)}),
    created-at: uint,
    series: (string-ascii 32)
  }
)

(define-map card-ownership uint principal)
(define-map rarity-requirements uint 
  {
    base-price: uint,
    max-supply: uint,
    current-supply: uint
  }
)

(define-map series-info (string-ascii 32) 
  {
    name: (string-ascii 64),
    description: (string-ascii 256),
    creator: principal,
    created-at: uint,
    card-count: uint,
    is-limited: bool,
    max-cards: uint
  }
)

(define-data-var last-card-id uint u0)
(define-data-var total-cards-created uint u0)

;; private functions
(define-private (is-owner (card-id uint))
  (let ((owner (unwrap! (map-get? card-ownership card-id) false)))
    (is-eq tx-sender owner)
  )
)

(define-private (is-contract-owner)
  (is-eq tx-sender contract-owner)
)

(define-private (is-valid-rarity (rarity uint))
  (and (>= rarity rarity-common) (<= rarity rarity-mythic))
)

;; public functions
(define-public (create-card (name (string-ascii 64)) 
                           (description (string-ascii 256)) 
                           (image-uri (string-utf8 256))
                           (rarity uint)
                           (attributes (list 10 {trait: (string-ascii 32), value: (string-ascii 32)}))
                           (series (string-ascii 32)))
  (let
    (
      (new-id (+ (var-get last-card-id) u1))
    )
    (asserts! (is-valid-rarity rarity) err-invalid-rarity)
    (try! (nft-mint? crypto-card new-id tx-sender))
    
    (map-set card-details new-id 
      {
        name: name,
        description: description,
        image-uri: image-uri,
        rarity: rarity,
        attributes: attributes,
        created-at: block-height,
        series: series
      }
    )
    
    (map-set card-ownership new-id tx-sender)
    
    (var-set last-card-id new-id)
    (var-set total-cards-created (+ (var-get total-cards-created) u1))
    
    (ok new-id)
  )
)

(define-public (transfer-card (card-id uint) (recipient principal))
  (begin
    (asserts! (is-owner card-id) err-not-authorized)
    
    (try! (nft-transfer? crypto-card card-id tx-sender recipient))
    (map-set card-ownership card-id recipient)
    
    (ok true)
  )
)

;; read-only functions
(define-read-only (get-card-details (card-id uint))
  (ok (unwrap! (map-get? card-details card-id) err-not-found))
)

(define-read-only (get-card-owner (card-id uint))
  (ok (unwrap! (map-get? card-ownership card-id) err-not-found))
)

(define-read-only (get-last-card-id)
  (ok (var-get last-card-id))
)

