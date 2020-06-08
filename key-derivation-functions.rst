.. _key derivation function:

Key derivation functions
------------------------

.. _description-8:

Description
~~~~~~~~~~~

A key derivation function is a function that derives one or more secret
values (the *keys*) from one secret value.

Many key derivation functions can also take a (usually optional) :term:`salt`
parameter. This parameter causes the key derivation function to not
always return the same output keys for the same input secret. As with
other cryptosystems, :term:`salt`\s are fundamentally different from the secret
input: :term:`salt`\s generally do not have to be secret, and can be re-used.

Key derivation functions can be useful, for example, when a
cryptographic protocol starts with a single secret value, such as a
shared password or a secret derived using Diffie-Hellman key exchange,
but requires multiple secret values to operate, such as encryption and
MAC keys. Another use case of key derivation functions is in
cryptographically secure random number generators, which we'll see in
more detail in a following chapter, where they are used to extract
randomness with high entropy density from many sources that each have
low entropy density.

There are two main categories of key derivation functions, depending on
the entropy content of the secret value, which determines how many
different possible values the secret value can take.

If the secret value is a user-supplied password, for example, it
typically contains very little entropy. There are very few values the
password will take. As we've already established in :ref:`a previous
section on password storage <password storage>`, that means it is
necessary that the key derivation function is hard to compute. That
means it requires a non-trivial amount of computing resources, such as
CPU cycles or memory. If the key derivation function were easy to
compute, an attacker could simply enumerate all possible values of the
shared secret, since there are few possibilities, and then compute the
key derivation function for all of them. As we've seen in that previous
section on password storage, this is how most modern attacks on password
stores work. Using an appropriate key derivation function would prevent
these attacks. In this chapter, we'll see scrypt, as well as other key
derivation functions in this category.

On the other hand, the secret value could also have a high entropy
content. For example, it could be a shared secret derived from a
Diffie-Hellman :term:`key agreement` protocol, or an API key consisting of
cryptographically random bytes (we'll discuss cryptographically secure
random number generation in the next chapter). In that case, it isn't
necessary to have a key derivation function that's hard to compute: even
if the key derivation function is trivial to compute, there are too many
possible values the secret can take, so an attacker would not be able to
enumerate them all. We'll see the best-of-breed of this kind of key
derivation function, HKDF, in this chapter.

Password strength
~~~~~~~~~~~~~~~~~

TODO: NIST Special Publication 800-63

PBKDF2
~~~~~~

bcrypt
~~~~~~

scrypt
~~~~~~

HKDF
~~~~

The HKDF, defined in RFC 5869 :cite:`rfc5869` and explained
in detail in a related paper :cite:`hkdf`, is a key
derivation function designed for high entropy inputs, such as shared
secrets from a Diffie-Hellman key exchange. It is specifically *not*
designed to be secure for low-entropy inputs such as passwords.

HKDF exists to give people an appropriate, off-the-shelf key derivation
function. Previously, key derivation was often something that was done
ad hoc for a particular standard. Usually these ad hoc solutions did not
have the extra provisions HKDF does, such as :term:`salt`\s or the optional info
parameter (which we'll discuss later in this section); and that's only
in the best case scenario where the KDF wasn't fundamentally broken to
begin with.

HKDF is based on HMAC. Like HMAC, it is a generic construction that uses
hash functions, and can be built using any cryptographically secure hash
function you want.

A closer look at HKDF
^^^^^^^^^^^^^^^^^^^^^

.. canned_admonition::
   :from_template: advanced

HKDF consists of two phases. In the first phase, called the *extraction
phase*, a fixed-length key is extracted from the input entropy. In the
second phase, called the *expansion phase*, that key is used to produce
a number of pseudorandom keys.

The extraction phase
''''''''''''''''''''

The extraction phase is responsible for extracting a small amount of
data with a high entropy content from a potentially large amount of data
with a smaller entropy density.

The extraction phase just uses HMAC with a :term:`salt`:

.. code:: python

   def extract(salt, data):
       return hmac(salt, data)

The :term:`salt` value is optional. If the :term:`salt` is not specified, a string of
zeroes equal to the length of the hash function's output is used. While
the :term:`salt` is technically optional, the designers stress its importance,
because it makes the independent uses of the key derivation function
(for example, in different applications, or with different users)
produce independent results. Even a fairly low-entropy :term:`salt` can already
contribute significantly to the security of the key derivation function.
:cite:`rfc5869` :cite:`hkdf`

The extraction phase explains why HKDF is not suitable for deriving keys
from passwords. While the extraction phase is very good at
*concentrating* entropy, it is not capable of *amplifying* entropy. It
is designed for compacting a small amount of entropy spread out over a
large amount of data into the same amount of entropy in a small amount
of data, but is not designed for creating a set of keys that are
difficult to compute in the face of a small amount of available entropy.
There are also no provisions for making this phase computationally
intensive. :cite:`rfc5869`

In some cases, it is possible to skip the extraction phase, if the
shared secret already has all the right properties, for example, if it
is a pseudorandom string of sufficient length, and with sufficient
entropy. However, sometimes this should not be done at all, for example
when dealing with a Diffie-Hellman shared secret. The RFC goes into
slightly more detail on the topic of whether or not to skip this step;
but it is generally inadvisable. :cite:`rfc5869`

The expansion phase
'''''''''''''''''''

In the expansion phase, the random data extracted from the inputs in the
extraction phase is expanded into as much data as is required.

The expansion step is also quite simple: chunks of data are produced
using HMAC, this time with the extracted secret, not with the public
:term:`salt`, until enough bytes are produced. The data being HMACed is the
previous output (starting with an empty string), an “info” parameter (by
default also the empty string), and a counter byte that counts which
block is currently being produced.

.. code:: python

   def expand(key, info=""):
       """Expands the key, with optional info."""
       output = ""
       for byte in map(chr, range(256)):
           output = hmac(key, output + info + byte)
           yield output

   def get_output(desired_length, key, info=""):
       """Collects output from the expansion step until enough
       has been collected; then returns that output."""
       outputs, current_length = [], 0
       for output in expand(key, info):
           outputs.append(output)
           current_length += len(output)

           if current_length >= desired_length:
               break
       else:
           # This block is executed when the for loop *isn't*
           # terminated by the ``break`` statement, which
           # happens when we run out of ``expand`` outputs
           # before reaching the desired length.
           raise RuntimeError("Desired length too long")

       return "".join(outputs)[:desired_length]

Like the :term:`salt` in the extraction phase, the “info” parameter is entirely
optional, but can actually greatly increase the security of the
application. The “info” parameter is intended to contain some
application-specific context in which the key derivation function is
being used. Like the :term:`salt`, it will cause the key derivation function to
produce different values in different contexts, further increasing its
security. For example, the info parameter may contain information about
the user being dealt with, the part of the protocol the key derivation
function is being executed for or the like. :cite:`rfc5869`
