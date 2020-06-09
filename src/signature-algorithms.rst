Signature algorithms
--------------------

.. _description-7:

Description
~~~~~~~~~~~

A signature algorithm is the public-key equivalent of a message
authentication code. It consists of three parts:

#. a key generation algorithm, which can be shared with other
   :term:`public-key algorithm`\s
#. a signature generation algorithm
#. a signature verification algorithm

Signature algorithms can be built using encryption algorithms. Using the
private key, we produce a value based on the message, usually using a
cryptographic hash function. Anyone can then use the public key to
retrieve that value, compute what the value should be from the message,
and compare the two to verify. The obvious difference between this and
:term:`public-key encryption` is that in signing, the private key is used to
produce the message (in this case the signature) and the public key is
used to interpret it, which is the opposite of how encryption and
decryption work.

The above explanation glosses over many important details. We'll discuss
real schemes in more detail below.

RSA-based signatures
~~~~~~~~~~~~~~~~~~~~

PKCS#1 v1.5
^^^^^^^^^^^

TODO (see #48)

PSS
^^^

TODO (see #49)

DSA
~~~

The Digital Signature Algorithm (DSA) is a US Federal Government
standard for digital signatures. It was first proposed by the National
Institute of Standards and Technology (NIST) in 1991, to be used in the
Digital Signature Standard (DSS). The algorithm is attributed to David
W. Kravitz, a former technical advisor at the NSA.

DSA key generation happens in two steps. The first step is a choice of
parameters, which can be shared between users. The second step is the
generation of public and private keys for a single user.

Parameter generation
^^^^^^^^^^^^^^^^^^^^

We start by picking an approved cryptographic hash function :math:`H`.
We also pick a key length :math:`L` and a prime length :math:`N`. While
the original DSS specified that :math:`L` be between 512 and 1024, NIST
now recommends a length of 3072 for keys with a security lifetime beyond
2030. As :math:`L` increases, so should :math:`N`.

Next we choose a prime :math:`q` of length :math:`N` bits; :math:`N`
must be less than or equal to the length of the hash output. We also
pick an *L*-bit prime :math:`p` such that :math:`p-1` is a multiple of
:math:`q`.

The last part is the most confusing. We have to find a number :math:`g`
whose :ref:`multiplicative order <multiplicative-order>`
:math:`\pmod{p}` is :math:`q`. The easy way to do this is to set
:math:`g \equiv 2^{(p-1)/q} \pmod{p}`. We can try another number greater
than 2, and less than :math:`p-1`, if :math:`g` comes out to equal 1.

Once we have parameters :math:`(p, q, g)`, they can be shared between
users.

Key generation
^^^^^^^^^^^^^^

Armed with parameters, it's time to compute public and private keys for
an individual user. First, select a random :math:`x` with
:math:`0 < x < q`. Next, calculate :math:`y` where
:math:`y \equiv g^x \pmod{p}`. This delivers a public key
:math:`(p, q, g, y)`, and private key :math:`x`.

Signing a message
^^^^^^^^^^^^^^^^^

In order to sign a message, the signer picks a random :math:`k` between
0 and :math:`q`. Picking that :math:`k` turns out to be a fairly
sensitive and involved process; but we'll go into more detail on that
later. With :math:`k` chosen, they then compute the two parts of the
signature :math:`r, s` of the message :math:`m`:

.. math::

   r \equiv (g^k \pmod p) \pmod q

.. math::

   s \equiv k^{-1} (H(m) + xr) \pmod q

If either of these happen to be 0 (a rare event, with 1 in :math:`q`
odds, and :math:`q` being a pretty large number), pick a different
:math:`k`.

TODO: Talk about k\ :sup:`-1`, the modular inverse (see #52)

Verifying a signature
^^^^^^^^^^^^^^^^^^^^^

Verifying the signature is a lot more complex. Given the message
:math:`m` and signature :math:`(r, s)`:

.. math::

   w \equiv s^{-1} \pmod q

.. math::

   u_1 \equiv wH(m) \pmod q

.. math::

   u_2 \equiv wr \pmod q

.. math::

   v \equiv (g^{u_1}y^{u_2} \pmod p) \pmod q

If the signature is valid that final result :math:`v` will be equal to
:math:`r`, the second part of the signature.

The trouble with :math:`k`
^^^^^^^^^^^^^^^^^^^^^^^^^^

While there is nothing wrong with DSA done right, it's very easy to get
it wrong. Furthermore, DSA is quite sensitive: even a small
implementation mistake results in a broken scheme.

In particular, the choice of the signature parameter :math:`k` is
critical. The requirements for this number are among the strictest of
all random numbers in cryptographic algorithms. For example, many
algorithms require a :term:`nonce`. A :term:`nonce` just has to be unique: you can use
it once, and then you can never use it again. It doesn't have to be
secret. It doesn't even have to be unpredictable. A :term:`nonce` can be
implemented by a simple counter, or a monotonic clock. Many other
algorithms, such as :term:`CBC mode`, use an initialization vector. It doesn't
have to be unique: it only has to be unpredictable. It also doesn't have
to be secret: initialization vectors are typically tacked on to the
ciphertext. DSA's requirements for the :math:`k` value are a combination
of all of these:

-  It has to be unique.
-  It has to be unpredictable.
-  It has to be secret.

Muddle with any of these properties, and an attacker can probably
retrieve your secret key, even with a modest amount of signatures. For
example, an attacker can recover the secret key knowing only a few bits
of :math:`k`, plus a large amount of valid signatures.
:cite:`nguyen:dsa`

It turns out that many implementations of DSA don't even get the
uniqueness part right, happily reusing :math:`k` values. That allows a
direct recovery of the secret key using basic arithmetic. Since this
attack is much simpler to understand, very commonly applicable, and
equally devastating, we'll discuss it in detail.

Suppose that an attacker sees multiple signatures :math:`(r_i, s_i)`,
for different messages :math:`m_i`, all with the same :math:`k`. The
attacker picks any two signatures :math:`(r_1, s_1)` and
:math:`(r_2, s_2)` of messages :math:`m_1` and :math:`m_2` respectively.
Writing down the equations for :math:`s_1` and :math:`s_2`:

.. math::

   s_1 \equiv k^{-1} (H(m_1) + xr_1) \pmod q

.. math::

   s_2 \equiv k^{-1} (H(m_2) + xr_2) \pmod q

The attacker can simplify this further: :math:`r_1` and :math:`r_2` must
be equal, following the definition:

.. math::

   r_i \equiv g^k \pmod q

Since the signer is reusing :math:`k`, and the value of :math:`r` only
depends on :math:`k`, all :math:`r_i` will be equal. Since the signer is
using the same key, :math:`x` is equal in the two equations as well.

Subtract the two :math:`s_i` equations from each other, followed by some
other arithmetic manipulations:

.. math::

   \begin{aligned}
   s_1 - s_2 & \equiv & k^{-1} (H(m_1) + xr) - k^{-1} (H(m_2) + xr) \pmod q \\
   & \equiv & k^{-1} \left( (H(m_1) + xr) - (H(m_2) + xr) \right) \pmod q \\
   & \equiv & k^{-1} (H(m_1) + xr - H(m_2) - xr) \pmod q \\
   & \equiv & k^{-1} (H(m_1) - H(m_2)) \pmod q
   \end{aligned}

This gives us the simple, direct solution for :math:`k`:

.. math::

   k \equiv \left(H(m_1) - H(m_2)\right) \left(s_1 - s_2\right)^{-1} \pmod q

The hash values :math:`H(m_1)` and :math:`H(m_2)` are easy to compute.
They're not secret: the messages being signed are public. The two values
:math:`s_1` and :math:`s_2` are part of the signatures the attacker saw.
So, the attacker can compute :math:`k`. That doesn't give him the
private key :math:`x` yet, though, or the ability to forge signatures.

Let's write the equation for :math:`s` down again, but this time
thinking of :math:`k` as something we know, and :math:`x` as the
variable we're trying to solve for:

.. math::

   s \equiv k^{-1} (H(m) + xr) \pmod q

All :math:`(r, s)` that are valid signatures satisfy this equation, so
we can just take any signature we saw. Solve for :math:`x` with some
algebra:

.. math::

   sk \equiv H(m) + xr \pmod q

.. math::

   sk - H(m) \equiv xr \pmod q

.. math::

   r^{-1}(sk - H(m)) \equiv x \pmod q

Again, :math:`H(m)` is public, plus the attacker needed it to compute
:math:`k`, anyway. They've already computed :math:`k`, and :math:`s` is
plucked straight from the signature. That just leaves us with
:math:`r^{-1} \pmod q` (read as: “the modular inverse of :math:`r`
modulo :math:`q`”), but that can be computed efficiently as well. (For
more information, see the appendix on modular arithmetic; keep in mind
that :math:`q` is prime, so the modular inverse can be computed
directly.) That means that the attacker, once they've discovered the
:math:`k` of any signature, can recover the private key directly.

So far, we've assumed that the broken signer would always use the same
:math:`k`. To make matters worse, a signer only has to re-use :math:`k`
*once* in any two signatures that the attacker can see for the attack to
work. As we've seen, if :math:`k` is repeated, the :math:`r_i` values
repeat as well. Since :math:`r_i` is a part of the signature, it's very
easy to see when the signer has made this mistake. So, even if reusing
:math:`k` is something the signer only does rarely (because their random
number generator is broken, for example), doing it once is enough for
the attacker to break the DSA scheme.

In short, reusing the :math:`k` parameter of a DSA signing operation
means an attacker recovers the private key.

TODO: Debian
http://rdist.root.org/2009/05/17/the-debian-pgp-disaster-that-almost-was/

ECDSA
~~~~~

TODO: explain (see #53)

As with regular DSA, the choice of :math:`k` is extremely critical.
There are attacks that manage to recover the signing key using a few
thousand signatures when only a few bits of the :term:`nonce` leak.
:cite:`demulder:ecdsa`

Repudiable authenticators
~~~~~~~~~~~~~~~~~~~~~~~~~

Signatures like the ones we described above provide a property called
*non-repudiation*. In short, it means that you can't later deny being
the sender of the signed message. Anyone can verify that the signature
was made using your private key, something only you could do.

That may not always be a useful feature; it may be more prudent to have
a scheme where only the intended recipient can verify the signature. An
obvious way to design such a scheme would be to make sure that the
recipient (or, in fact, anyone else) could have computed an identical
value.

Such messages can be repudiated; such a scheme is often called “deniable
authentication”. While it authenticates the sender to the intended
recipient, the sender can later deny (to third parties) having sent the
message. Equivalently, the recipient can't convince anyone else that the
sender sent that particular message.
