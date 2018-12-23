#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: SCObject.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/IMCodeElement.rb"
require "ttc/bin/sc_object/SCObject.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: SCObject
  # ��    ��: Ʊ�����̿����֥������Ȥξ����������륯�饹
  #===================================================================
  class SCObject
    include CommonModule

    attr_accessor :hState, :sObjectType, :sObjectID

    #=================================================================
    # ��  ��: Ʊ�����̿����֥������Ȥν����
    #=================================================================
    def initialize(sObjectID, hObjectInfo, sObjectType, aPath, bIsPre)
      check_class(String, sObjectID)    # ���֥�������ID
      check_class(Hash, hObjectInfo)    # ���֥������Ⱦ���
      check_class(String, sObjectType)  # ���֥������ȥ�����
      check_class(Array, aPath)         # �롼�Ȥ���Υѥ�
      check_class(Bool, bIsPre)         # pre_condition�⤫

      @cConf   = Config.new()
      @hState = {}

      @sObjectID   = sObjectID
      @sObjectType = sObjectType  # ���֥������ȤΥ�����
      @aPath       = aPath + [@sObjectID]

      # Ʊ�����̿����֥������ȶ�����ʬ
      @hState[TSR_PRM_DATACNT]  = nil  # ��Ǽ�Ǥ���ǡ�����[�ǡ������塼/ͥ���٥ǡ������塼]
      @hState[TSR_PRM_STSKLIST] = nil  # �����Ԥ��������Υꥹ��[�ǡ������塼/ͥ���٥ǡ������塼]
      @hState[TSR_PRM_RTSKLIST] = nil  # �����Ԥ��������Υꥹ��[�ǡ������塼/ͥ���٥ǡ������塼]
      @hState[TSR_PRM_DATALIST] = nil  # �����ΰ�Υǡ����Υꥹ��[�ǡ������塼/ͥ���٥ǡ������塼]
      @hState[TSR_PRM_WTSKLIST] = nil  # �Ԥ��������Υꥹ��[���ޥե�/���٥�ȥե饰/�᡼��ܥå���/����Ĺ����ס���]
      @hState[TSR_PRM_ATR]      = nil  # °��[���ޥե�/���٥�ȥե饰/�ǡ������塼/ͥ���٥ǡ������塼/�᡼��ܥå���/����Ĺ����ס���]
      @hState[TSR_PRM_CLASS]    = nil  # ���饹

      # SEMAPHORE
      @hState[TSR_PRM_MAXSEM]   = nil  # ����񸻿�
      @hState[TSR_PRM_ISEMCNT]  = nil  # ����񸻿�
      @hState[TSR_PRM_SEMCNT]   = nil  # ���߻񸻿�

      # EVENTFLAG
      @hState[TSR_PRM_IFLGPTN]  = nil  # ����ӥåȥѥ�����
      @hState[TSR_PRM_FLGPTN]   = nil  # ���ߥӥåȥѥ�����

      # P_DATAQUEUE
      @hState[TSR_PRM_MAXDPRI]  = nil  # �ǡ���ͥ���٤κ�����

      # MAILBOX
      @hState[TSR_PRM_MAXMPRI]  = nil  # ��å�����ͥ���٤κ�����
      @hState[TSR_PRM_MSGLIST]  = nil  # �����Ԥ���å������Υꥹ��

      # MEMORYPOOL
      @hState[TSR_PRM_BLKCNT]   = nil  # �����Ǥ���֥�å��ν����
      @hState[TSR_PRM_FBLKCNT]  = nil  # �����Ǥ���֥�å��θ��߿�
      @hState[TSR_PRM_BLKSZ]    = nil  # �֥�å��Υ�����
      @hState[TSR_PRM_MPF]      = nil  # ����ס�����Ƭ���ϻ������ѿ�

      # SPINLOCK
      @hState[TSR_PRM_SPNSTAT]  = nil  # ���ԥ��å��ξ���
      @hState[TSR_PRM_PROCID]   = nil  # ���ԥ��å���������Ƥ������ñ��ID

      pre_attribute_check(hObjectInfo, aPath + [@sObjectID], bIsPre)
      store_object_info(hObjectInfo)
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ���̤�Ʊ�����̿����֥������ȥǡ�����
    #         @hState������
    #=================================================================
    def store_object_info(hObjectInfo)
      check_class(Hash, hObjectInfo)  # ���֥������Ⱦ���

      # ��Ǽ
      set_specified_attribute(hObjectInfo)
      hObjectInfo.each{|atr, val|
        case atr
        when TSR_PRM_TYPE
          # ���⤷�ʤ�

        when TSR_PRM_DTQCNT, TSR_PRM_PDQCNT
          @hState[TSR_PRM_DATACNT] = val

        when TSR_PRM_SEMATR, TSR_PRM_FLGATR, TSR_PRM_DTQATR, TSR_PRM_PDQATR, TSR_PRM_MBXATR, TSR_PRM_MPFATR
          @hState[TSR_PRM_ATR] = val

        else
          @hState[atr] = val
        end
      }

      # �ꥹ�ȷϥѥ�᡼����TESRY��°���������Ҥ���Ƥ����硤
      # ������򥻥åȤ���
      [TSR_PRM_WTSKLIST, TSR_PRM_STSKLIST, TSR_PRM_RTSKLIST, TSR_PRM_DATALIST, TSR_PRM_MSGLIST].each{|sAtr|
        if (hObjectInfo[sAtr].nil?() && hObjectInfo.has_key?(sAtr))
          @hState[sAtr] = []
        end
      }
    end

    #=================================================================
    # ��  ��: Ʊ�����̿����֥������Ȥ�pre_condition������cElement�˳�
    #         Ǽ����
    #=================================================================
    def gc_obj_ref(cElement, hProcUnitInfo, bContext, bCouLock)
      check_class(IMCodeElement, cElement) # �������
      check_class(Hash, hProcUnitInfo)     # ����ñ�̾���
      check_class(Bool, bContext)          # ����������ƥ����Ȥ�
      check_class(Bool, bCouLock)          # CPU��å���


      # CPU_LOCK
      if (check_cpu_lock() && (bCouLock != true))
        cElement.set_syscall(hProcUnitInfo, get_cpu_lock(bContext))
      end

      cElement.set_local_var(hProcUnitInfo[:id], @sRefStrVar, @sRefStrType)
      cElement.set_syscall(hProcUnitInfo, "#{@sRefAPI}(#{@sObjectID}, &#{@sRefStrVar})")

      # °��
      if (!@hState[TSR_PRM_ATR].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefAtr}", @hState[TSR_PRM_ATR])
      end

      # ������ʬ
      # �Ԥ��������Υꥹ��[SEMAPHORE, EVENTFLAG, MAILBOX, MEMORYPOOL]
      if (!@hState[TSR_PRM_WTSKLIST].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefWaitCnt}", @hState[TSR_PRM_WTSKLIST].size())

        if (!@hState[TSR_PRM_WTSKLIST].empty?())
          cElement.set_local_var(hProcUnitInfo[:id], VAR_TSKID, TYP_ID)

          @hState[TSR_PRM_WTSKLIST].each_with_index{|hTaskInfo, nIndex|
            case @sObjectType
            when TSR_OBJ_SEMAPHORE, TSR_OBJ_MAILBOX, TSR_OBJ_MEMORYPOOL
              cElement.set_syscall(hProcUnitInfo, "#{@sRefRWaitAPI}(#{@sObjectID}, #{nIndex + 1}, &#{VAR_TSKID})")
              cElement.set_assert(hProcUnitInfo, VAR_TSKID, hTaskInfo.keys[0])

            when TSR_OBJ_EVENTFLAG
              cElement.set_local_var(hProcUnitInfo[:id], VAR_WAIPTN, TYP_FLGPTN)
              cElement.set_local_var(hProcUnitInfo[:id], VAR_WFMODE, TYP_MODE)
              cElement.set_syscall(hProcUnitInfo, "#{@sRefRWaitAPI}(#{@sObjectID}, #{nIndex + 1}, &#{VAR_TSKID}, &#{VAR_WAIPTN}, &#{VAR_WFMODE})")
              cElement.set_assert(hProcUnitInfo, "#{VAR_TSKID}", hTaskInfo.keys[0])
              cElement.set_assert(hProcUnitInfo, VAR_WAIPTN, hTaskInfo[hTaskInfo.keys[0]][TSR_VAR_WAIPTN])
              cElement.set_assert(hProcUnitInfo, VAR_WFMODE, hTaskInfo[hTaskInfo.keys[0]][TSR_VAR_WFMODE])

            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end
          }
        end
      end

      # DATAQUEUE��P_DATAQUEUE
      # �ǡ��������ΰ�ꥹ��
      if (!@hState[TSR_PRM_DATACNT].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefDataCnt}", @hState[TSR_PRM_DATACNT])

        if (!@hState[TSR_PRM_DATALIST].nil?())
          cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefDataList}", @hState[TSR_PRM_DATALIST].size())

          if (!@hState[TSR_PRM_DATALIST].empty?())
            case @sObjectType
            when TSR_OBJ_DATAQUEUE
              cElement.set_local_var(hProcUnitInfo[:id], VAR_DATA, TYP_INTPTR_T)
              @hState[TSR_PRM_DATALIST].each_with_index{|hData, nIndex|
                cElement.set_syscall(hProcUnitInfo, "#{FNC_REF_DATA}(#{sObjectID}, #{nIndex + 1}, &#{VAR_DATA})")
                cElement.set_assert(hProcUnitInfo, VAR_DATA, hData[TSR_VAR_DATA])
              }

            when TSR_OBJ_P_DATAQUEUE
              cElement.set_local_var(hProcUnitInfo[:id], VAR_DATA, TYP_INTPTR_T)
              cElement.set_local_var(hProcUnitInfo[:id], VAR_DATAPRI, TYP_PRI)

              @hState[TSR_PRM_DATALIST].each_with_index{|hData, nIndex|
                cElement.set_syscall(hProcUnitInfo, "#{FNC_REF_PRI_DATA}(#{sObjectID}, #{nIndex + 1}, &#{VAR_DATA}, &#{VAR_DATAPRI})")
                cElement.set_assert(hProcUnitInfo, VAR_DATA, hData[TSR_VAR_DATA])
                cElement.set_assert(hProcUnitInfo, VAR_DATAPRI, hData[TSR_VAR_DATAPRI])
              }

            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end
          end
        end
      end

      # �����Ԥ��������ꥹ��
      if (!@hState[TSR_PRM_STSKLIST].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefSWaitList}", @hState[TSR_PRM_STSKLIST].size())

        if (!@hState[TSR_PRM_STSKLIST].empty?())
          cElement.set_local_var(hProcUnitInfo[:id], VAR_TSKID, TYP_ID)
          cElement.set_local_var(hProcUnitInfo[:id], VAR_DATA, TYP_INTPTR_T)

          case @sObjectType
          when TSR_OBJ_DATAQUEUE
            @hState[TSR_PRM_STSKLIST].each_with_index{|hTaskInfo, nIndex|
              cElement.set_syscall(hProcUnitInfo, "#{FNC_REF_SWAIT_DTQ}(#{@sObjectID}, #{nIndex + 1}, &#{VAR_TSKID}, &#{VAR_DATA})")
              cElement.set_assert(hProcUnitInfo, VAR_TSKID, hTaskInfo.keys[0])
              cElement.set_assert(hProcUnitInfo, VAR_DATA, hTaskInfo[hTaskInfo.keys[0]][TSR_VAR_DATA])
            }

          when TSR_OBJ_P_DATAQUEUE
            cElement.set_local_var(hProcUnitInfo[:id], VAR_DATAPRI, TYP_PRI)
            @hState[TSR_PRM_STSKLIST].each_with_index{|hTaskInfo, nIndex|
              cElement.set_syscall(hProcUnitInfo, "#{FNC_REF_SWAIT_PDQ}(#{@sObjectID}, #{nIndex + 1}, &#{VAR_TSKID}, &#{VAR_DATA}, &#{VAR_DATAPRI})")
              cElement.set_assert(hProcUnitInfo, VAR_TSKID, hTaskInfo.keys[0])
              cElement.set_assert(hProcUnitInfo, VAR_DATA, hTaskInfo[hTaskInfo.keys[0]][TSR_VAR_DATA])
              cElement.set_assert(hProcUnitInfo, VAR_DATAPRI, hTaskInfo[hTaskInfo.keys[0]][TSR_VAR_DATAPRI])
            }

          else
            abort(ERR_MSG % [__FILE__, __LINE__])
          end
        end
      end

      # �����Ԥ��������ꥹ��
      if (!@hState[TSR_PRM_RTSKLIST].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefRWaitList}", @hState[TSR_PRM_RTSKLIST].size())

        if (!@hState[TSR_PRM_RTSKLIST].empty?())
          cElement.set_local_var(hProcUnitInfo[:id], VAR_TSKID, TYP_ID)

          @hState[TSR_PRM_RTSKLIST].each_with_index{|hTaskInfo, nIndex|
            cElement.set_syscall(hProcUnitInfo, "#{@sRefRWaitAPI}(#{@sObjectID}, #{nIndex + 1}, &#{VAR_TSKID})")
            cElement.set_assert(hProcUnitInfo, VAR_TSKID, hTaskInfo.keys[0])
          }
        end
      end

      # MAILBOX
      # ��å������ꥹ��
      if (!@hState[TSR_PRM_MSGLIST].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefMsgCnt}", @hState[TSR_PRM_MSGLIST].size())

        if (!@hState[TSR_PRM_MSGLIST].empty?())
          @hState[TSR_PRM_MSGLIST].each_with_index{|hData, nIndex|
            if (hData.has_key?(TSR_VAR_MSGPRI))
              cElement.set_local_var(hProcUnitInfo[:id], VAR_P_MSG_PRI, TYP_T_P_MSG_PRI)
              cElement.set_syscall(hProcUnitInfo, "#{FNC_REF_MSG}(#{@sObjectID}, #{nIndex + 1}, #{CST_MSG2}&#{VAR_P_MSG_PRI})")
              cElement.set_assert(hProcUnitInfo, VAR_P_MSG_PRI, "&#{hData[TSR_VAR_MSG]}")
              cElement.set_assert(hProcUnitInfo, "#{VAR_P_MSG_PRI}->#{STR_MSGPRI}", hData[TSR_VAR_MSGPRI])
            else
              cElement.set_local_var(hProcUnitInfo[:id], VAR_P_MSG, TYP_T_P_MSG)
              cElement.set_syscall(hProcUnitInfo, "#{FNC_REF_MSG}(#{@sObjectID}, #{nIndex + 1}, #{CST_MSG2}&#{VAR_P_MSG})")
              cElement.set_assert(hProcUnitInfo, VAR_P_MSG, "&#{hData[TSR_VAR_MSG]}")
            end
          }
        end
      end

      # SEMAPHORE
      if (!@hState[TSR_PRM_SEMCNT].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_SEMCNT}", @hState[TSR_PRM_SEMCNT])
      end

      if (!@hState[TSR_PRM_ISEMCNT].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_ISEMCNT}", @hState[TSR_PRM_ISEMCNT])
      end

      if (!@hState[TSR_PRM_MAXSEM].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_MAXSEM}", @hState[TSR_PRM_MAXSEM])
      end

      # EVENTFLAG
      if (!@hState[TSR_PRM_FLGPTN].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_FLGPTN}", @hState[TSR_PRM_FLGPTN])
      end

      if (!@hState[TSR_PRM_IFLGPTN].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_IFLGPTN}", @hState[TSR_PRM_IFLGPTN])
      end

      # MAILBOX
      if (!@hState[TSR_PRM_MAXMPRI].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_MAXMPRI}", @hState[TSR_PRM_MAXMPRI])
      end

      # P_DATAQUEUE
      if (!@hState[TSR_PRM_MAXDPRI].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_MAXDPRI}", @hState[TSR_PRM_MAXDPRI])
      end

      # MEMORYPOOL
      if (!@hState[TSR_PRM_BLKCNT].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_BLKCNT}", @hState[TSR_PRM_BLKCNT])
      end

      if (!@hState[TSR_PRM_FBLKCNT].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_FBLKCNT}", @hState[TSR_PRM_FBLKCNT])
      end

      if (!@hState[TSR_PRM_BLKSZ].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_BLKSZ}", @hState[TSR_PRM_BLKSZ])
      end

      if (!@hState[TSR_PRM_MPF].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_MPF}", @hState[TSR_PRM_MPF])
      end

      # SPINLOCK
      if (!@hState[TSR_PRM_SPNSTAT].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_SPNSTAT}", @hState[TSR_PRM_SPNSTAT])
      end

      # CPU_UNLOCK
      if (check_cpu_lock() && (bCouLock != true))
        cElement.set_syscall(hProcUnitInfo, get_cpu_unlock(bContext))
      end
    end

    #=================================================================
    # ��  ��: cpu_lock��ɬ�פ��ɤ�����Ƚ�Ǥ���ɬ�פǤ����true��
    #         ɬ�פǤʤ����false���֤�
    #=================================================================
    def check_cpu_lock()
      if !(@hState[TSR_PRM_STSKLIST].nil?() || @hState[TSR_PRM_STSKLIST].empty?()) ||
         !(@hState[TSR_PRM_RTSKLIST].nil?() || @hState[TSR_PRM_RTSKLIST].empty?()) ||
         !(@hState[TSR_PRM_DATALIST].nil?() || @hState[TSR_PRM_DATALIST].empty?()) ||
         !(@hState[TSR_PRM_WTSKLIST].nil?() || @hState[TSR_PRM_WTSKLIST].empty?()) ||
         !(@hState[TSR_PRM_MSGLIST].nil?() || @hState[TSR_PRM_MSGLIST].empty?())
        return true # [Bool]CPU��å���ɬ��
      end

      return false # [Bool]CPU��å�������
    end

    #=================================================================
    # ��  ��: ����������ƥ����Ȥξ���cpu_lock��
    #         �󥿥�������ƥ����Ȥξ���icpu_lock���֤�
    #=================================================================
    def get_cpu_lock(bCpuLock)
      check_class(Bool, bCpuLock)

      if (bCpuLock == true)
        sCpuLock = "#{API_LOC_CPU}()"
      else
        sCpuLock = "#{API_ILOC_CPU}()"
      end

      return sCpuLock # [String]cpu_lock��icpu_lock
    end

    #=================================================================
    # ��  ��: ����������ƥ����Ȥξ���unl_lock��
    #         �󥿥�������ƥ����Ȥξ���iunl_lock���֤�
    #=================================================================
    def get_cpu_unlock(bCpuLock)
      check_class(Bool, bCpuLock)

      if (bCpuLock == true)
        sCpuUnlock = "#{API_UNL_CPU}()"
      else
        sCpuUnlock = "#{API_IUNL_CPU}()"
      end

      return sCpuUnlock # [String]unl_lock��iunl_cpu
    end
  end
end
