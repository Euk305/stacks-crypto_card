
;; cryptp-card_contract
;; Basic NFT functionality for crypto cards

;; constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-not-authorized (err u103))

;; data maps and vars
(define-non-fungible-token crypto-card uint)

(define-map card-details uint 
  {
    name: (string-ascii 64),
    description: (string-ascii 256),
    image-uri: (string-utf8 256),
    created-at: uint
  }
)

(define-map card-ownership uint principal)
(define-data-var last-card-id uint u0)

;; private functions
(define-private (is-owner (card-id uint))
  (let ((owner (unwrap! (map-get? card-ownership card-id) false)))
    (is-eq tx-sender owner)
  )
)

(define-private (is-contract-owner)
  (is-eq tx-sender contract-owner)
)

;; public functions
(define-public (create-card (name (string-ascii 64)) 
                           (description (string-ascii 256)) 
                           (image-uri (string-utf8 256)))
  (let
    (
      (new-id (+ (var-get last-card-id) u1))
    )
    (try! (nft-mint? crypto-card new-id tx-sender))
    
    (map-set card-details new-id 
      {
        name: name,
        description: description,
        image-uri: image-uri,
        created-at: block-height
      }
    )
    
    (map-set card-ownership new-id tx-sender)
    (var-set last-card-id new-id)
    
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

