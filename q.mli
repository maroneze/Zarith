(**
   Rationals.

   This modules builds arbitrary precision rationals on top of arbitrary
   integers from module Z.


   This file is part of the Zarith library 
   http://forge.ocamlcore.org/projects/zarith .
   It is distributed under LGPL 2 licensing, with static linking exception.
   See the LICENSE file included in the distribution.
   
   Copyright (c) 2010-2011 Antoine Miné, Abstraction project.
   Abstraction is part of the LIENS (Laboratoire d'Informatique de l'ENS),
   a joint laboratory by:
   CNRS (Centre national de la recherche scientifique, France),
   ENS (École normale supérieure, Paris, France),
   INRIA Rocquencourt (Institut national de recherche en informatique, France).

 *)

(** {1 Types} *)

type t = {
    num: Z.t; (** Numerator. *)
    den: Z.t; (** Denominator, >= 0 *)
  }
(** A rational is represented as a pair numerator/denominator, reduced to
    have a non-negative denominator and no common factor.
    This form is canonical (enabling polymorphic equality and hashing).
    The representation allows three special numbers: [inf] (1/0), [-inf] (-1/0)
    and [undef] (0/0).
 *)

(** {1 Construction} *)

val make: Z.t -> Z.t -> t
(** [make num den] constructs a new rational equal to [num]/[den].
    It takes care of putting the rational in canonical form.
 *)

val zero: t
val one: t
val minus_one:t
(** 0, 1, -1. *)

val inf: t
(** 1/0. *)

val minus_inf: t
(** -1/0. *)

val undef: t
(** 0/0. *)

val of_bigint: Z.t -> t
val of_int: int -> t
val of_int32: int32 -> t
val of_int64: int64 -> t
val of_nativeint: nativeint -> t
(** Conversions from various integer types. *)

val of_string: string -> t
(** Converts a string to a rational.
    Plain decimals, and [/] separated decimal ratios (with optional sign) are
    understood.
    Additionally, the special [inf], [-inf], and [undef] are recognized
    (they can also be typeset respectively as [1/0], [-1/0], [0/0]).
 *)


(** {1 Inspection} *)

val num: t -> Z.t
(** Get the numerator. *)

val den: t -> Z.t
(** Get the denominator. *)


(** {1 Testing} *)

type kind = 
  | ZERO   (** 0 *)
  | INF    (** infinity, i.e. 1/0 *)
  | MINF   (** minus infinity, i.e. -1/0 *)
  | UNDEF  (** undefined, i.e., 0/0 *)
  | NZERO  (** well-defined, non-infinity, non-zero number *) 
(** Rationals can be categorized into different kinds, depending mainly on
    whether the numerator and/or denominator is null.
 *)

val classify: t -> kind
(** Determines the kind of a rational. *)

val is_real: t -> bool
(** Whether the argument is non-infinity and non-undefined. *)

val sign: t -> int
(** Returns 1 if the argument is positive (including inf), -1 if it is
    negative (including -inf), and 0 if it is null or undefined.
 *)

val compare: t -> t -> int
(** [compare x y] compares [x] to [y] and returns 1 if [x] is strictly
    greater that [y], -1 if it is strictly smaller, and 0 if they are
    equal.
    This is a total ordering.
    Infinities are ordered in the natural way, while undefined is considered
    the smallest of all: undef = undef < -inf <= -inf < x < inf <= inf.
    This is consistent with OCaml's handling of floating-point infinities 
    and NaN.

    OCaml's polymorphic comparison will NOT return a result consistent with
    the ordering of rationals.
 *)

val equal: t -> t -> bool
(** Equality testing. 
    This is consistent with [compare]; in particular, [undef]=[undef].
 *)

val min: t -> t -> t
(** Returns the smallest of its arguments. *)

val max: t -> t -> t
(** Returns the largest of its arguments. *)


(** {1 Conversions} *)

val to_bigint: t -> Z.t
val to_int: t -> int
val to_int32: t -> int32
val to_int64: t -> int64
val to_nativeint: t -> nativeint
(** Convert to integer by truncation.
    Raises a [Divide_by_zero] if the argument is an infinity or undefined. 
    Raises a [Z.Overflow] if the result does not fit in the destination
    type.
*)

val to_string: t -> string
(** Converts to human-readable, decimal, [/]-separated rational. *)


(** {1 Arithmetic operations} *)

(**
   In all operations, the result is [undef] if one argument is [undef].
   Other operations can return [undef]: such as [inf]-[inf], [inf]*0, 0/0.
 *)

val neg: t -> t
(** Negation. *)

val abs: t -> t
(** Absolute value. *)

val add: t -> t -> t
(** Addition. *)

val sub: t -> t -> t
(** Subtraction. We have [sub x y] = [add x (neg y)]. *)

val mul: t -> t -> t
(** Multiplication. *)

val inv: t -> t
(** Inverse.
    Note that [inv 0] is defined, and equals [inf].
 *)

val div: t -> t -> t
(** Division.
    We have [div x y] = [mul x (inv y)], and [inv x] = [div one x].
 *)

val mul_2exp: t -> int -> t
(** [mul_2exp x n] multiplies [x] by 2 to the power of [n]. *)

val div_2exp: t -> int -> t
(** [div_2exp x n] divides [x] by 2 to the power of [n]. *)