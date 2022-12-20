namespace Helpers.Result;

public abstract class Result<T,R>{
    private Result(){}

    public sealed class Ok : Result<T,R>{
        public Ok(T value) => Value = value;
        public T Value { get; }
    }

    public sealed class Error : Result<T,R>{
        public Error(R value) => Value = value;
        public R Value { get; }
    }
}