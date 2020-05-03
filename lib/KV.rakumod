
unit package KV:auth<littlebenlittle>:ver<0.0.0>;

our grammar KV {
    token TOP {
        <.ws>*
        <kv-pair>+ % <.ws>
        <.ws>*
    }
    token kv-pair { <key> "=" <val> }
    token key { <.alpha> [<.alnum> | "-"]* }
    token val {
        | <raw-val>
        | "'" <raw-val> "'" 
        | '"' <raw-val> '"' 
    }
    token raw-val { [<.alnum> | "-" | ":" | \h]+ }
    token ws  { \v | \h }
}

our class KV-Actions {
    method TOP ($/) {
        make %($/<kv-pair>.map: *.made);
    }
    method kv-pair ($/) {
        make $/<key>.Str => $/<val><raw-val>.Str;
    }
}

our sub parse (Str:D $kvs -->Hash:D) is export {
    KV.parse($kvs, :actions(KV-Actions));
    my $env = $/.made;
    die "could not parse $kvs" unless $env;
    my %env = %($env);
    return %env;
}

