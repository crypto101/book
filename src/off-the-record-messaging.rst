Off-The-Record Messaging (OTR)
------------------------------

.. _description-11:

Description
~~~~~~~~~~~

:term:`OTR messaging` is a protocol for securing instant messaging communication
between people :cite:`borisov:otr`. It intends to be the
online equivalent of a private, real-life conversation. It encrypts
messages, preventing eavesdroppers from reading them. It also
authenticates peers to each other, so they know who they're talking to.
Despite authenticating peers, it is designed to be deniable:
participants can later deny to third parties anything they said to each
other. It is also designed to have perfect forward secrecy: even a
compromise of a long-term public key pair doesn't compromise any
previous conversations.

The deniability and perfect forward secrecy properties are very
different from those of other systems such as OpenPGP. OpenPGP
intentionally guarantees non-repudiability. It's a great property if
you're signing software packages, talking on mailing lists or signing
business invoices, but the authors of :term:`OTR` argue that those aren't
desirable properties for the online equivalent of one-on-one
conversations. Furthermore, OpenPGP's static model of communication
makes the constant key renegotiation to facilitate :term:`OTR`'s perfect forward
secrecy impossible.

:term:`OTR` is typically configured opportunistically, which means that it will
attempt to secure any communication between two peers, if both
understand the protocol, without interfering with communication where
the other peer does not. The protocol is supported in many different
instant messaging clients either directly, or with a plugin. Because it
works over instant messages, it can be used across many different
instant messaging protocols.

A peer can signal that they would like to speak :term:`OTR` with an explicit
message, called the :term:`OTR` Query message. If the peer is just willing to
speak :term:`OTR` but doesn't require it, they can optionally invisibly add that
information to a plaintext message. That happens with a clever system of
whitespace tags: a bunch of whitespace such as spaces and tab characters
are used to encode that information. An :term:`OTR`\-capable client can interpret
that tag and start an :term:`OTR` conversation; a client that isn't :term:`OTR`\-capable
just displays some extra whitespace.

:term:`OTR` uses many of the primitives we've seen so far:

-  Symmetric key encryption (AES in CTR mode)
-  :term:`Message authentication codes <message authentication code>` (HMAC with SHA-1)
-  Diffie-Hellman key exchange

:term:`OTR` also utilizes another mechanism, called the SMP, to check if peers
arrived at the same shared secret.

.. _key-exchange-1:

Key exchange
~~~~~~~~~~~~

In :term:`OTR`, AKE relies heavily on Diffie-Hellman key exchange, extended with
a significant number of extra, interlocking checks. The Diffie-Hellman
exchange itself uses a fixed 1536-bit prime with a fixed generator
:math:`g`.

We suppose that two participants, named Alice and Bob want to
communicate and are willing to exchange sensitive data with each other.
Alice and Bob have a long-term DSA authentication key pair each, which
we'll call (:math:`p_A, s_A)` and :math:`(p_B, s_B)` respectively.

The protocol also relies on a number of other primitives:

-  A 128-bit block cipher. In :term:`OTR`, this is always AES. In this section,
   we'll call block cipher encryption and decryption :math:`E` and
   :math:`D`, respectively.
-  A hash function, :math:`H`. In :term:`OTR`, this is SHA1.
-  A :term:`message authentication code`, :math:`M`. In :term:`OTR`, this is HMAC-SHA1.
-  A signing function, :math:`S`.

Commit message
^^^^^^^^^^^^^^

Initially Alice and Bob are in a protocol state where they wait for the
peer to initiate an :term:`OTR` connection, and advertise their own capability
of speaking :term:`OTR`.

Let's suppose that Bob chooses to initiate an :term:`OTR` conversation with
Alice. His client sends an :term:`OTR` Commit Message, and then transitions to a
state where he waits for a reply from from Alice's client.

To send a commit message, a client picks a random 128-bit value
:math:`r` and a random 320-bit (or larger) Diffie-Hellman secret
:math:`x`. It then sends :math:`E(r, g^x)` and :math:`H(g^x)` to the
peer.

Key message
^^^^^^^^^^^

Alice's client has received Bob's client's advertisement to start an :term:`OTR`
session. Her client replies with a key message, which involves creating
a new Diffie-Hellman key pair. She picks a 320-bit (or larger)
Diffie-Hellman secret :math:`y` and sends :math:`g^y` to Bob.

Reveal Signature Message
^^^^^^^^^^^^^^^^^^^^^^^^

Now that Alice has sent her public Diffie-Hellman key, Bob can complete
his part of the Diffie-Hellman protocol. Alice can't continue yet,
because she hasn't seen Bob's public key.

When we discussed Diffie-Hellman, we noted that it does not
*authenticate* the peer. Bob can compute a secret, but doesn't know he's
talking to Alice. As with TLS and other systems using Diffie-Hellman,
this problem is solved by authenticating the key exchange.

After verifying that Alice's public key is a valid value, Bob computes
the shared secret :math:`s = (g^y)^x`. Using a key derivation function,
he derives several keys from :math:`s`: two AES keys
:math:`c, c^\prime`, and four MAC keys
:math:`m_1, m_1^\prime, m_2, m_2^\prime`.

He chooses an identification number :math:`i_B` for his current
Diffie-Hellman key pair :math:`(x, g^x)`. This will be important once
Alice and Bob generate new key pairs, which they will do later on in the
:term:`OTR` protocol.

Bob computes:

.. math::

   M_B = M_{m_1}(g^x, g^y, p_B, i_B)

.. math::

   X_B = (p_B, i_B, S(p_B, M_B))

He sends Alice :math:`r, E_c(X_B), M_{m_2}(E_c(X_B))`.

Signature Message
^^^^^^^^^^^^^^^^^

Alice can now confirm she's talking to Bob directly, because Bob signed
the authenticator for the exchange :math:`M_B` with his long-term DSA
key.

Alice can now also compute the shared secret: Bob has sent her
:math:`r`, which was previously used to encrypt Bob's Diffie-Hellman
public key. She then computes :math:`H(g^x)` herself, to compare it
against what Bob sent. By completing her side of the Diffie-Hellman
exchange (:math:`s = (g^x)^y`), she derives the same keys:
:math:`c, c^\prime, m_1, m_1^\prime, m_2, m_2^\prime`. Using :math:`m_2`, she
can verify :math:`M_{m_2}(E_c(X_B))`. Once that message is verified, she can
safely decrypt it using her computed :math:`c`.

She can then also compute :math:`M_B = M_{m_1}(g^x, g^y, p_B, i_B)`, and
verifies that it is the same as Bob sent. By verifying the signed
portion :math:`S(p_B, M_B)` against Bob's public key, she has now
unambiguously tied the current interaction to Bob's long-term
authentication key.

She then computes the same values Bob computed to tie his long-term key
to the short-term handshake, so that Bob can also authenticate her. She
chooses an identification number :math:`i_A` for her current DH keypair
:math:`(y, g^y)`, computes :math:`M_A = M_{m_1^\prime}(g^y, g^x, p_A, i_A)`
and :math:`X_A = p_A, i_A, S(p_A, M_A)`. Finally, she sends Bob
:math:`E_{c^\prime}(X_A), M_{m_2^\prime}(E_c(X_B))`.

Authenticating Alice
^^^^^^^^^^^^^^^^^^^^

Now Bob can also authenticate Alice, again by mirroring steps. First, he
verifies :math:`M_{m_2^\prime}(E_c(X_B))`. This allows him to check that
Alice saw the same :math:`X_B` he sent.

Once he decrypts :math:`E_{c^\prime}(X_A)`, he has access to
:math:`X_A`, which is Alice's long-term public key information. He can
then compute :math:`M_A = M_{m_1^\prime}(g^y, g^x, p_A, i_A)` to compare it with
the version Alice sent. Finally, he verifies :math:`S(p_A, M_A)` with Alice's
public key.


What have we accomplished?
^^^^^^^^^^^^^^^^^^^^^^^^^^

If all checks succeed then Alice and Bob have completed an authenticated
Diffie-Hellman exchange and have a shared secret that only the two of
them know.

Now that you've seen both sides of the authenticated handshake, you can
see why so many different keys are derived from the Diffie-Hellman
secret. Keys marked with a prime (:math:`\prime`) are for messages
originating from the second peer (the one responding to the
advertisement, in our case, Alice); keys without a prime are for the
initiating peer (in our case, Bob).

Data exchange
~~~~~~~~~~~~~

TODO: Explain (https://otr.cypherpunks.ca/Protocol-v3-4.0.0.html), #33
