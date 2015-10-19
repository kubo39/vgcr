# x64 only.


module Valgrind
  module ClientRequest
    RUNNING_ON_VALGRIND  = 0x1001
    DISCARD_TRANSLATIONS = 0x1002
    CLIENT_CALL0 = 0x1101
    CLIENT_CALL1 = 0x1102
    CLIENT_CALL2 = 0x1103
    CLIENT_CALL3 = 0x1104
    COUNT_ERRORS = 0x1201
    GDB_MONITOR_COMMAND = 0x1202
    MALLOCLIKE_BLOCK = 0x1301
    RESIZEINPLACE_BLOCK = 0x130b
    FREELIKE_BLOCK   = 0x1302
    CREATE_MEMPOOL   = 0x1303
    DESTROY_MEMPOOL  = 0x1304
    MEMPOOL_ALLOC    = 0x1305
    MEMPOOL_FREE     = 0x1306
    MEMPOOL_TRIM     = 0x1307
    MOVE_MEMPOOL     = 0x1308
    MEMPOOL_CHANGE   = 0x1309
    MEMPOOL_EXISTS   = 0x130a
    PRINTF           = 0x1401
    PRINTF_BACKTRACE = 0x1402
    PRINTF_VALIST_BY_REF = 0x1403
    PRINTF_BACKTRACE_VALIST_BY_REF = 0x1404
    STACK_REGISTER   = 0x1501
    STACK_DEREGISTER = 0x1502
    STACK_CHANGE     = 0x1503
    LOAD_PDB_DEBUGINFO = 0x1601
    MAP_IP_TO_SRCLOC = 0x1701
    CHANGE_ERR_DISABLEMENT = 0x1801
  end

  def self.running_on_valgrind() : UInt64
    return vgrs(0_u64, ClientRequest::RUNNING_ON_VALGRIND.to_u64,
                0_u64, 0_u64, 0_u64, 0_u64, 0_u64)
  end

  def self.count_errors() : UInt64
    return vgrs(0_u64, ClientRequest::COUNT_ERRORS.to_u64,
                0_u64, 0_u64, 0_u64, 0_u64, 0_u64)
  end

  private def self.vgrs(default : UInt64,
                        request : UInt64,
                        arg1 : UInt64,
                        arg2 : UInt64,
                        arg3 : UInt64,
                        arg4 : UInt64,
                        arg5 : UInt64) : UInt64
    dst :: UInt64
    args = [request, arg1, arg2, arg3, arg4, arg5]
    asm("
         rolq $$3,  %rdi
         rolq $$13, %rdi
         rolq $$61, %rdi
         rolq $$51, %rdi
         xchgq %rbx, %rbx"
        : "={rdx}"(dst)
        : "{rax}"(args.to_unsafe), "0"(default)
        : "cc", "memory"
        : "volatile")
    dst
  end
end
