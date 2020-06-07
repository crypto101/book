Glossary
========

.. glossary::

   AEAD
      Authenticated Encryption with Associated Data

   AES
      Advanced Encryption Standard

   AKE
      authenticated key exchange

   ARX
      add, rotate, XOR

   BEAST
      Browser Exploit Against SSL/TLS

   CBC
      cipher block chaining

   CDN
      content distribution network

   CSPRNG
      cryptographically secure pseudorandom number generator

   CSRF
      :term:`cross-site request forgery`

   DES
      Data Encryption Standard

   FIPS
      Federal Information Processing Standards

   GCM
      Galois Counter Mode

   HKDF
      HMAC-based (Extract-and-Expand) Key Derivation Function

   HMAC
      Hash-based Message Authentication Code

   HSTS
      HTTP Strict Transport Security

   IV
      :term:`initialization vector`

   KDF
      key derivation function

   MAC
      message authentication code

   MITM
      man-in-the-middle

   OCB
      offset codebook

   OTR
      off-the-record

   PRF
      pseudorandom function

   PRNG
      pseudorandom number generator

   PRP
      pseudorandom permutation

   RSA
      Rivest Shamir Adleman

   SMP
      socialist millionaire protocol

   secret-key encryption
      Encryption that uses the same key for both encryption and decryption. Also
      known as symmetric-key encryption. Contrast with :term:`public-key encryption`

   symmetric-key encryption
      See :term:`secret-key encryption`

   keyspace
      The set of all possible keys

   block cipher
      Symmetric encryption algorithm that encrypts and decrypts blocks of fixed size

   substitution-permutation network
      Generic design for block ciphers where the block is enciphered by repeated
      substitutions and permutations

   stream cipher
      Symmetric encryption algorithm that encrypts streams of arbitrary size

   mode of operation
   modes of operation
      Generic construction that encrypts and decrypts streams, built from a
      block cipher

   ECB mode
      Electronic code book mode; mode of
      operation where plaintext is separated into blocks that are
      encrypted separately under the same key. The default mode in many
      cryptographic libraries, despite many security issues

   CBC mode
      Cipher block chaining mode; common mode
      of operation where the previous ciphertext block is XORed with the
      plaintext block during encryption. Takes an initialization vector,
      which assumes the role of the "block before the first block"

   initialization vector
      Data used to initialize some algorithms such as :term:`CBC mode`.
      Generally not required to be secret, but required to be unpredictable.
      Compare :term:`nonce`, :term:`salt`

   CTR mode
      Counter mode; a :term:`nonce` combined with a counter produces a sequence
      of inputs to the block cipher; the resulting ciphertext blocks are the keystream

   nonce
      **N**\umber used **once**. Used in many cryptographic protocols. Generally
      does not have to be secret or unpredictable, but does have to be unique.
      Compare :term:`initialization vector`, :term:`salt`

   AEAD mode
      Class of :term:`block cipher` :term:`mode of operation` that provides
      authenticated encryption, as well as authenticating some unencrypted
      associated data

   OCB mode
      Offset codebook mode; high-performance :term:`AEAD mode`, unfortunately
      encumbered by patents

   GCM mode
      Galois counter mode; :term:`AEAD mode` combining :term:`CTR mode` with a
      :term:`Carter-Wegman MAC`

   message authentication code
      Small piece of information used to verify authenticity and integrity of a message.
      Often called a tag

   one-time MAC
      :term:`message authentication code` that can only be used securely for a
      single message. Main benefit is increased performance over re-usable :term:`MAC`

   Carter-Wegman MAC
      Reusable :term:`message authentication code` scheme built from a :term:`one-time MAC`.
      Combines benefits of performance and ease of use

   GMAC
      :term:`message authentication code` part of :term:`GCM mode` used separately

   salt
      Random data that is added to a cryptographic primitive (usually a one-way
      function such as a cryptographic hash function or a key derivation
      function) Customizes such functions to produce different outputs (provided
      the salt is different). Can be used to prevent e.g. dictionary attacks.
      Typically does not have to be secret, but secrecy may improve security
      properties of the system. Compare :term:`nonce`, :term:`initialization vector`

   public-key algorithm
      Algorithm that uses a pair of two related but distinct keys. Also known
      as :term:`asymmetric-key algorithm`. Examples include :term:`public-key
      encryption` and most :term:`key exchange` protocols


   asymmetric-key algorithm
      See :term:`public-key algorithm`

   public-key encryption
      Encryption using a pair of distinct keys for encryption and decryption.
      Also known as asymmetric-key encryption. Contrast with :term:`secret-key
      encryption`

   asymmetric-key encryption
      See :term:`public-key encryption`


   key exchange
      The process of exchanging keys across an insecure medium using a
      particular cryptographic protocol. Typically designed to be secure against
      eavesdroppers. Also known as key agreement

   key agreement
      See :term:`key exchange`

   oracle
      A "black box" that will perform some computation for you

   encryption oracle
      An :term:`oracle` that will encrypt some data

   OTR messaging
      Off-the-record messaging, messaging protocol that intends to mimic the
      properties of a real-live private conversation. Piggy-backs onto existing
      instant messaging protocols

   cross-site request forgery
      Kind of attack where a malicious website tricks the browser into making
      requests to another website. Can be prevented by properly authenticating
      requests instead of relying on ambient authority such as session cookies
