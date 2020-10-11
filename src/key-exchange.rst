.. _key-exchange:

Key exchange
------------

.. _description-3:

Description
~~~~~~~~~~~

:term:`Key exchange <key exchange>` protocols attempt to resolve a problem that, at first glance,
seems impossible. Alice and Bob, who never met before, must agree
on a secret value. The communication channel they use is insecure:
lets assume the channel is being eavesdropped on
and everything they send across is open knowledge.

We demonstrate such a protocol here. Alice and Bob have
a shared secret and only communicate over the insecure channel. Although
Eve literally has all information Alice and Bob send to each
other, she is unable to use the information to uncover their shared
secret.

Whitfield Diffie and Martin Hellman, two cryptographic pioneers discovered 
this protocol known today as Diffie-Hellman. They
suggested calling the protocol Diffie-Hellman-Merkle :term:`key exchange` in
honor of Ralph Merkle's contributions. While Merkle's contributions
certainly deserve honor, the term has not caught on. We use the common term 
for the benefit of the reader.

Practical implementations of Diffie-Hellman rely on mathematical
problems believed to be complex to solve in the “wrong”
direction, but easy to compute in the “right” direction. Understanding
the mathematical implementation is not necessary to understand the
principle behind the protocol. Most people find it easy to
understand without the mathematical complexity. So, we explain
Diffie-Hellman in the abstract first, without any mathematical
constructs. Afterwards, we look at two practical implementations.

Abstract Diffie-Hellman
~~~~~~~~~~~~~~~~~~~~~~~

An analogy based on mixing colors helps describe Diffie-Hellman. 
We mix colors following these rules:

-  Mixing two colors into a third color is very easy.
-  Mixing two or more colors in different order results in the same
   color.
-  Mixing colors is *one-way*. It is impossible to determine which colors were mixed 
   and whether multiple colors were used to create a given color. Even
   if you know a color was mixed, and if you know some of the colors
   mixed, you still have no idea about the actual color(s).

We demonstrate with a mixing function. 
A secret color is produced only known by Alice and Bob. Later, we simply
describe the concrete implementation of those functions for a
concrete :term:`key exchange` scheme.

We walk through an entire exchange with Eve, the eavesdropper, to illustrate 
why the secret remains secure.
Eve listens to all messages sent across the network.
We keep track of everything Eve knows, what she can compute, and
see *why* Eve cannot compute the shared secret between Alice and Bob.

To launch the protocol, Alice and Bob must agree on a base color and can
communicate across the network. It is okay if Eve intercepts the
message and knows the color. Typically, the base color is a
fixed part of the protocol; Alice and Bob do not need to communicate it.
After this step, Alice, Bob and Eve all have the same information: the
base color.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-eve.svg
   :align: center

Alice and Bob select a random color and mix it with the base
color.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-secret.svg
   :align: center

At the end of this step, Alice and Bob know their respective secret
color, a mix of the secret color and the base color, and the base
color itself. Everyone, including Eve, knows the base color.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-eve-secret.svg
   :align: center

Then, Alice and Bob send their mixed colors over the network. Eve
sees both mixed colors, but she cannot figure out neither of their
*secret* colors. Even though Eve knows the base, she cannot
“un-mix” the colors sent over the network. [#]_

.. figure:: ./Illustrations/DiffieHellman/mixed-secret.svg
   :align: center

.. [#]
   While this might seem like an easy operation with black-and-white
   approximations of color mixing, keep in mind that this is just a
   failure of the illustration: our assumption is that this is hard.


At the end of this step, Alice and Bob know the base, their respective
secrets, their respective mixed colors, and each other's mixed colors.
Eve knows the base color and both mixed colors.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-eve-mixed.svg
   :align: center


Once Alice and Bob receive each other's mixed color, they add their own
secret color. Since the order of the mixing is irrelevant,
they have the same secret.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-shared-mixed.svg
   :align: center

Eve cannot fully perform the computation. Eve has both mixed colors, so she may consider
finishing the computation with either Alice or Bob's secret color. 
Though she does not have any secret color to fully perform the computation. She tries 
mixing the two mixed colors, which have Alice's and Bob's secret
colors mixed into them. However, the mixture has the base color added
twice. This results in a different color than the shared secret color computed by
Alice and Bob (base color added once).

Diffie-Hellman with discrete logarithms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section describes a practical implementation of the Diffie-Hellman
algorithm using the discrete logarithm problem. It 
provides mathematical background, and requires modular arithmetic to
understand. If you are unfamiliar with modular arithmetic, you can
either skip this chapter, or first read the :ref:`mathematical background appendix
<modular-arithmetic>`.

Discrete log Diffie-Hellman is based on the idea that computing
:math:`y` in the following equation is easy (at least for a computer):

.. math::

   y \equiv g^x \pmod{p}

However, computing :math:`x` given :math:`y`, :math:`g` and :math:`p` is
believed to be very hard. This is a discrete logarithm problem
because a similar operation without modular arithmetic is simply called a
logarithm.

Now we describe the concrete implementation of the abstract Diffie-Hellman
process discussed earlier. The common base color is a large prime
:math:`p` and the base :math:`g`. The “color mixing” operation is the
equation given above, where :math:`x` is the input value and :math:`y`
is the resulting mixed value.

When Alice or Bob select their random numbers :math:`r_A` and
:math:`r_B`, they are mixed with the base to produce the mixed numbers
:math:`m_A` and :math:`m_B`:

.. math::

   m_A \equiv g^{r_A} \pmod{p}

.. math::

   m_B \equiv g^{r_B} \pmod{p}

The numbers are sent across the network where Eve sees them. The
premise of the discrete logarithm problem is that it is okay to do so
because figuring out :math:`r` in :math:`m \equiv g^r \pmod{p}` is
supposedly very hard.

Once Alice and Bob have each other's mixed numbers, they add their own
secret number to it. For example, Bob would compute:

.. math::

   s \equiv (g^{r_A})^{r_B} \pmod{p}

While Alice's computation looks different, they get the same result
because :math:`(g^{r_A})^{r_B} \equiv (g^{r_B})^{r_A} \pmod{p}`. This is
the shared secret.

Because Eve does not have :math:`r_A` or :math:`r_B`, she is unable to perform
the equivalent computation. She only has the base number :math:`g`, plus the
mixed numbers :math:`m_A \equiv g^{r_A} \pmod{p}` and
:math:`m_B \equiv g^{r_B} \pmod{p}`. These are useless to her. She
needs :math:`r_A` and/or :math:`r_B` to make the
computation like Alice and Bob.

TODO: Say something about active MITM attacks where the attacker picks
smooth values to produce weak secrets?

Diffie-Hellman with elliptic curves
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section describes a practical implementation of the Diffie-Hellman
algorithm using the elliptic curve discrete logarithm problem. It
provides mathematical background, and requires a very
basic understanding of the mathematics behind elliptic curve
cryptography. If you are unfamiliar with elliptic curves, you can either
skip this chapter, or first read the :ref:`mathematical background appendix
<elliptic-curves>`.

A benefit of the elliptic curve Diffie-Hellman variant is that
the required key size is much, much smaller than the variant based on
the discrete log problem. This is because the fastest algorithms for
breaking the discrete log problem have a larger asymptotic complexity
than their elliptic curve variants. For example, take the number field sieve
for discrete logarithms. It is a state-of-the-art algorithm for attacking
discrete logarithm-based Diffie-Hellman and has time complexity:

.. math::

   L\left[1/3,\sqrt[3]{64/9}\right]

Which is more than polynomial (but less than exponential) in the number
of digits. On the other hand, the fastest algorithms most useful for
breaking the elliptic curve discrete log problem are all complex:

.. math::

   L\left[1, 1/2\right] = O(\sqrt{n})

Relatively speaking, it is much harder to solve the
elliptic curve problem than it is to solve the regular discrete log
problem using state-of-the-art algorithms for both. The flip side 
is that for equivalent security levels, the elliptic curve
algorithm needs much smaller key
sizes :cite:`rsa:keysizes` :cite:`nist:keymanagement` [#]_:

.. [#]
   These figures are actually for the RSA problem versus the equivalent
   elliptic curve problem, but their security levels are sufficiently
   close to give you an idea.

====================== ===================== =======================
Security level in bits Discrete log key bits Elliptic curve key bits
====================== ===================== =======================
56                     512                   112
80                     1024                  160
112                    2048                  224
128                    3072                  256
256                    15360                 512
====================== ===================== =======================

.. _remaining-problems-3:

Remaining problems
~~~~~~~~~~~~~~~~~~

Using Diffie-Hellman, we can agree on shared secrets across an insecure
Internet, safe from eavesdroppers. However, while an attacker may not be
able to simply get the secret from eavesdropping, an active attacker can
still break the system. If such an attacker, usually called Mallory, is
in between Alice and Bob, she can still perform the Diffie-Hellman
protocol twice: once with Alice, where Mallory pretends to be Bob, and
once with Bob, where Mallory pretends to be Alice.

.. figure:: ./Illustrations/DiffieHellman/MITM.svg
   :align: center

There are two shared secrets here: one between Alice and Mallory, and
one between Mallory and Bob. The attacker (Mallory) can then simply take
all the messages they get from one person and send them to the other,
they can look at the plaintext messages, remove messages, and they can
also modify them in any way they choose.

To make matters worse, even if one of the two participants was somehow
aware that this was going on, they would have no way to get the other
party to believe them. After all: Mallory performed the successful
Diffie-Hellman exchange with the unwitting victim, she has all the
correct shared secrets. Bob has no shared secrets with Alice, just with
Mallory; there's no way for him to prove that he's the legitimate
participant. As far as Alice can tell, Bob just chose a few random
numbers. There's no way to link any key that Bob has with any key that
Alice has.

Attacks like these are called MITM attacks, because the attacker
(Mallory) is in between the two peers (Alice and Bob). Given that the
network infrastructure that we typically use to send messages is run by
many different operators, this kind of attack scenario is very
realistic, and a secure cryptosystem will have to address them somehow.

While the Diffie-Hellman protocol successfully produced a shared secret
between two peers, there are clearly some pieces of the puzzle still
missing to build those cryptosystems. We need tools that help us
authenticate Alice to Bob and vice versa, and we need tools that help
guarantee message integrity, allowing the receiver to verify that the
received messages are in fact the messages the sender intended to send.
