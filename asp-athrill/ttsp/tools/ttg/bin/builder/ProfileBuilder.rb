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
#  $Id: ProfileBuilder.rb 6 2012-09-03 11:06:01Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/IMCodeElement.rb"
require "common/bin/test_scenario/TestScenario.rb"
require "bin/product/IntermediateCode.rb"

module TTG

  #==================================================================
  # ���饹̾: ProfileBuilder
  # ����  ��: ASP / FMP Builder�Υ����ѡ����饹
  #==================================================================
  class ProfileBuilder
    include CommonModule

    #================================================================
    # ������: ���󥹥ȥ饯��
    #================================================================
    def initialize()
      # ��֥����ɤν�������������ƥ��ȥ��ʥꥪ���̤ξ�����ɲä���
      @cIMCode = IntermediateCode.new()

      @cConf = Config.new() # ����ե��������
    end

    #================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ���������롼����Υ����ɤ���������
    #================================================================
    def build_ini_rtn(aIniRtn)
      check_class(Array, aIniRtn) # ������롼���󥯥饹����

      # �����Х������롼�������Ƭ�˻��äƤ���
      aSortIniRtn = []
      aIniRtn.each{|cIniRtn|
        if (cIniRtn.hState[TSR_PRM_GLOBAL] == true)
          aSortIniRtn.push(cIniRtn)
        end
      }

      # �����Х������롼����ʳ����������
      aIniRtn.each{|cIniRtn|
        if (cIniRtn.hState[TSR_PRM_GLOBAL] != true)
          aSortIniRtn.push(cIniRtn)
        end
      }

      bFirstFlg = true
      aSortIniRtn.each{|cIniRtn|
        # ������롼����ñ�ΤΥƥ���ID�����
        @cIMCode.set_testid_level("#{IMC_TTG_INIRTN}_#{cIniRtn.sObjectID}")

        # ������롼����Υ���ǥ�������٥����
        @cIMCode.set_condition_level(TTG_LBL_INIRTN)

        # ������롼�����ɬ�פʤ��٤ƤΥ���������
        @cIMCode.add_element(cIniRtn.gc_ini_rtn(bFirstFlg))

        # ���Τ�true�Ȥ���
        bFirstFlg = false
      }
    end

    #================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ���齪λ�롼����Υ����ɤ���������
    #================================================================
    def build_ter_rtn(aTerRtn)
      check_class(Array, aTerRtn) # ��λ�롼���󥯥饹����

      # �����Х뽪λ�롼�������Ƭ�˻��äƤ���
      aSortTerRtn = []
      aTerRtn.each{|cTerRtn|
        if (cTerRtn.hState[TSR_PRM_GLOBAL] == true)
          aSortTerRtn.push(cTerRtn)
        end
      }

      # �����Х뽪λ�롼����ʳ����������
      aTerRtn.each{|cTerRtn|
        if (cTerRtn.hState[TSR_PRM_GLOBAL] != true)
          aSortTerRtn.push(cTerRtn)
        end
      }

      aSortTerRtn.each{|cTerRtn|
        # ��λ�롼����ñ�ΤΥƥ���ID�����
        @cIMCode.set_testid_level("#{IMC_TTG_TERRTN}_#{cTerRtn.sObjectID}")

        # ��λ�롼����Υ���ǥ�������٥����
        @cIMCode.set_condition_level(TTG_LBL_TERRTN)

        # ��λ�롼�����ɬ�פʥ����å��ݥ���Ȱʳ��Υ���������
        @cIMCode.add_element(cTerRtn.gc_ter_rtn_info())
      }

      # �����å��ݥ���Ȥ�ս�ǽ��Ϥ���
      aSortTerRtn.reverse.each{|cTerRtn|
        @cIMCode.add_element(cTerRtn.gc_ter_rtn_checkpoint())
      }

      # �ǽ�ν�λ�롼����˥ƥ��Ƚ�λ��å���������(�ս�Ǽ¹Ԥ���뤿��)
      @cIMCode.add_element(aSortTerRtn[0].gc_finish_message())
    end

    #================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ�ν�����롼�����̵ͭ���֤�
    #================================================================
    def exist_ini_rtn(cTestScenario)
      check_class(TestScenario, cTestScenario) # �ƥ��ȥ��ʥꥪ���饹

      return cTestScenario.exist_ini_rtn()  # [Bool]������롼�����̵ͭ
    end

    #================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ�ν�λ�롼�����̵ͭ���֤�
    #================================================================
    def exist_ter_rtn(cTestScenario)
      check_class(TestScenario, cTestScenario) # �ƥ��ȥ��ʥꥪ���饹

      return cTestScenario.exist_ter_rtn()  # [Bool]��λ�롼�����̵ͭ
    end

    #================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ������֥����ɤ���������
    #================================================================
    def build(cTestScenario, bPrevGainTime)
      check_class(TestScenario, cTestScenario) # �ƥ��ȥ��ʥꥪ���饹
      check_class(Bool, bPrevGainTime)         # ���Υƥ��ȥ��ʥꥪ�ˤ��������ư��ե饰

      @cTS = cTestScenario.dup()
      @hTestMain = @cTS.get_main_task_proc() # �ᥤ�󥿥���ID����

      # �ƥ��ȥ��ʥꥪ���Ͻ���
      start_test_scenario(bPrevGainTime)

      # pre_condition������
      build_pre_condition()

      # do��post_condition������
      @cTS.get_do_post_index().each{|nIndex|
        # do�ν���
        build_do(nIndex)

        # post_condition�ν���
        if (@cTS.check_lastpost_condition(nIndex) == true)
          build_lastpost_condition(nIndex)
        else
          build_post_condition(nIndex)
        end
      }
    end

    #================================================================
    # ������: �ƥ��ȥ��ʥꥪ���Ͻ���
    #================================================================
    def start_test_scenario(bPrevGainTime)
      check_class(Bool, bPrevGainTime)  # ���Υƥ��ȥ��ʥꥪ�ˤ��������ư��ե饰

      hMainTask  = @cIMCode.hMainTask
      hCheckMain = @cIMCode.hCheckMain

      # ���Υƥ��ȥ��ʥꥪ���о줹�����ñ�̤��ɲ�
      # �ǽ�Ū�ʵ�ư����������Ʊ���˹Ԥ�
      cElement = IMCodeElement.new(:common)
      cElement.set_proc_unit(@hTestMain[:id], @hTestMain[:bootcnt])
      @cTS.get_proc_units(cElement)


      # �����Х�/�������ѿ�������ɲ�(����ñ�̤�TSR_PRM_VAR���������Ƥ�����)
      @cTS.gc_global_local_var(cElement)


      # �ץ�ȥ�����������ɲ�
      cElement.set_header(@hTestMain[:id], IMC_FUNC_TYPE)
      @cTS.gc_header(cElement)


      # ��ŪAPI������ɲ�
      @cTS.gc_config(cElement)


      # �ƥ���ID���Ϥ�syslog����
      cElement.set_code(hMainTask, "#{TTG_NL}#{TTG_TB}syslog_0(LOG_NOTICE, \"#{@cTS.sTestID}: Start\")")


      # ����ư��˴ؤ����Ѳ���̵����硤���⤷�ʤ�
      if (@cTS.bGainTime == bPrevGainTime)
      # ������֤�ư�������(=���Υƥ��ȥ��ʥꥪ�Ǥϻ������)�����֤�ư����
      elsif (@cTS.bGainTime == true)
        cElement.set_code(hMainTask, "#{FNC_START_TICK}()")
      # ������֤�ư�����ʤ����(=���Υƥ��ȥ��ʥꥪ�Ǥϻ���ư��)�����֤�ߤ��
      else
        cElement.set_code(hMainTask, "#{FNC_STOP_TICK}()")
      end


      # ACTIVATE�Ǥ������ߥϥ�ɥ餬�����硤�����Х��ѿ������������ӥ��󥯥����
      if (@cTS.exist_int_hdr() == true)
        aIntHdrID = @cTS.get_activate_proc_unit_id(TSR_OBJ_INTHDR)
        aIntHdrID.each{|sObjectID|
          cElement.set_global_var("#{sObjectID}_#{VAR_BOOTCNT}", "enum ENUM_#{sObjectID}", "#{sObjectID}_#{TTG_ENUM_INVALID}")
          cElement.set_code(hMainTask, "#{sObjectID}_#{VAR_BOOTCNT}++")
        }
      end

      # ACTIVATE�Ǥ������ߥ����ӥ��롼���󤬤����硤�����Х��ѿ������������ӥ��󥯥����
      # (����ߥ����ӥ��롼����ξ�硤1�ĤΥ����Х�IP�����Ǥ褤)
      if (@cTS.exist_isr() == true)
        aIsrID = @cTS.get_activate_proc_unit_id(TSR_OBJ_ISR)
        if (!aIsrID.empty?())
          cElement.set_global_var("#{TTG_LBL_ISR}_#{VAR_BOOTCNT}", "enum ENUM_#{TTG_LBL_ISR}", "#{TTG_LBL_ISR}_#{TTG_ENUM_INVALID}")
          cElement.set_code(hMainTask, "#{TTG_LBL_ISR}_#{VAR_BOOTCNT}++")
        end
      end

      # ACTIVATE�Ǥ���CPU�㳰�ϥ�ɥ餬�����硤�����Х��ѿ������������ӥ��󥯥����
      if (@cTS.exist_exception() == true)
        aExcID = @cTS.get_activate_proc_unit_id(TSR_OBJ_EXCEPTION)
        aExcID.each{|sObjectID|
          cElement.set_global_var("#{sObjectID}_#{VAR_BOOTCNT}", "enum ENUM_#{sObjectID}", "#{sObjectID}_#{TTG_ENUM_INVALID}")
          cElement.set_code(hMainTask, "#{sObjectID}_#{VAR_BOOTCNT}++")
        }
      end


      # TA_STA°���μ����ϥ�ɥ餬�����硤�����Х��ѿ���������ե饰�򥻥åȡ�
      if (@cTS.exist_cyclic_sta() == true)
        hCycle = @cTS.get_all_object_info(TSR_OBJ_CYCLE)
        hCycle.each{|sObjectID, hObjectInfo|
          if (hObjectInfo.hState[TSR_PRM_ATR] == KER_TA_STA)
            cElement.set_global_var("#{sObjectID}_flg", TYP_BOOL_T, false)
            cElement.set_code(hMainTask, "#{sObjectID}_flg = true")

            # �оݼ����ϥ�ɥ����Ƭ�Ǽ����ϥ�ɥ餬��ư���ʤ��褦return������Ԥ�
            cElement.set_pre_code(sObjectID, "if (#{sObjectID}_flg == false) {", false)
            cElement.set_pre_code(sObjectID, "#{TTG_TB}return")
            cElement.set_pre_code(sObjectID, "}", false)
          end
        }
      end


      # GCOV�������ξ�硤������resume����
      if (@cConf.enable_gcov?() && (@cTS.bGcovAll == true))
        cElement.set_code(hMainTask, FNC_GCOV_TTG_C_RESUME)
      end

      cElement.set_code(hMainTask, "#{@hTestMain[:id].downcase()}()")

      # GCOV�������ξ�硤������pause����
      if (@cConf.enable_gcov?() && (@cTS.bGcovAll == true))
        cElement.set_code(hMainTask, FNC_GCOV_TTG_C_PAUSE)
      end


      # �ᥤ�󥿥����ξ��֥����å�����
      cElement.set_code(hMainTask, "#{hCheckMain[:id]}()")

      # �ƥ���ID��λ��syslog����
      cElement.set_code(hMainTask, "syslog_0(LOG_NOTICE, \"#{@cTS.sTestID}: OK\")")
      @cIMCode.add_element(cElement)

      # �ƥ���ID��٥���ɲä���
      @cIMCode.set_testid_level(@cTS.sTestID)

      # ɬ�פʥ����������å��θĿ��򥢥åץǡ���
      @cIMCode.update_stack_size(@cTS.get_stack_num())
    end

    #================================================================
    # ������: checkfinish�Υ����ɤ���������
    #================================================================
    def build_finish_cp(bIsTerRtn)
      check_class(Bool, bIsTerRtn) # ��λ�롼����̵ͭ�ե饰

      cElement = IMCodeElement.new(:common)

      # ��λ�롼����̵����С�check_finish
      if (bIsTerRtn == false)
        # GCOV�ν���
        if (@cConf.enable_gcov?() && @cConf.is_asp?())
          cElement.set_code(@cIMCode.hMainTask, "#{TTG_NL}#{TTG_TB}#{FNC_GCOV_C_RESUME}")
          cElement.set_code(@cIMCode.hMainTask, FNC_GCOV_C_DUMP)
        end
        cElement.set_checkfinish(@cIMCode.hMainTask)
      # ��λ�롼���󤬤���С�check_point
      else
        cElement.set_checkpoint(@cIMCode.hMainTask)
        cElement.set_code(@cIMCode.hMainTask, "#{API_EXT_KER}()")
      end

      @cIMCode.add_element(cElement)
    end

    #================================================================
    # ��  ��: �ؿ���ͭ�������ñ�̤ν��������Ԥ������ɤ���������
    #================================================================
    def build_shared_proc_unit(hSharedProcUnitInfo, sObjectType)
      check_class(Hash, hSharedProcUnitInfo) # �ؿ���ͭ�������ñ�̤ξ���
      check_class(String, sObjectType)       # �оݤȤ������ñ�̥�����

      cElement = IMCodeElement.new()

      aEnaIntIntHdr = []

      # �оݤȤ������ñ�̤�ɬ�פʾ�������
      hSharedProcUnitInfo.sort.each{|aObjectInfo|
        # ����ñ�̾����ɲ�
        cElement.set_proc_unit(aObjectInfo[0], aObjectInfo[1].hState[TSR_PRM_BOOTCNT])

        # �ץ�ȥ�����������ɲ�
        cElement.set_header(aObjectInfo[0], sObjectType)

        # ��ŪAPI������ɲ�
        aObjectInfo[1].gc_config(cElement)

        # ����ߥϥ�ɥ�ϰ�Χ��Ƭ�ǳ�����׵�ե饰���ꥢ�ؿ�(���ϻ�����)��¹Ԥ���
        if (sObjectType == TSR_OBJ_INTHDR)
          cElement.set_pre_code(aObjectInfo[0], "#{FNC_I_BEGIN_INT}(#{aObjectInfo[1].hState[TSR_PRM_INTNO]})")
          # ����Ū�ʳ�����׵᥯�ꥢ����
          # (�ġ��ΥǥХ������Ф��������׵�Υ��ꥢ����/�������åȰ�¸)
          cElement.set_pre_code(aObjectInfo[0], "#{FNC_CLEAR_INT_REQ}(#{aObjectInfo[1].hState[TSR_PRM_INTNO]})")

          # ����ߥϥ�ɥ�ϰ�Χ��Ƭ�ǳ�����׵�ե饰���ꥢ�ؿ�(��λ������)��¹Ԥ���
          cElement.set_post_code(aObjectInfo[0], "#{FNC_I_END_INT}(#{aObjectInfo[1].hState[TSR_PRM_INTNO]})")

          # TA_ENAINT°���γ���ߥϥ�ɥ�ξ�����Ǽ���Ƥ���
          if (aObjectInfo[1].hState[TSR_PRM_ATR] == KER_TA_ENAINT)
            hProcUnitInfo = {:id => aObjectInfo[0], :prcid => aObjectInfo[1].hState[TSR_PRM_PRCID], :bootcnt => TTG_MAIN_BOOTCNT}
            aEnaIntIntHdr.push([hProcUnitInfo, aObjectInfo[0], aObjectInfo[1].hState[TSR_PRM_INTNO], aObjectInfo[1].hState[TSR_PRM_PRCID]])
          end
        # CPU�㳰�ϥ�ɥ�ϰ�Χ��Ƭ�ǥեå������ؿ���¹Ԥ���
        elsif (sObjectType == TSR_OBJ_EXCEPTION)
          cElement.set_pre_code(aObjectInfo[0], "#{FNC_CPUEXC_HOOK}(#{aObjectInfo[1].hState[TSR_PRM_EXCNO]}, #{@cConf.get_exception_arg_name()})")
        end
      }

      @cIMCode.add_element(cElement)

      # TA_ENAINT°���γ���ߥϥ�ɥ餬�����硤��Ƭ�ǳ���ߥϥ�ɥ�ε�ư��ǧ��Ԥ���dis_int����
      aEnaIntIntHdr.each{|aIntHdr|
        cElementCommon = IMCodeElement.new(:common)
        cElementCommon.set_global_var("#{aIntHdr[1]}_#{VAR_BOOTCNT}", "enum ENUM_#{aIntHdr[1]}", "#{aIntHdr[1]}_#{TTG_ENUM_INVALID}")
        cElementCommon.set_code(@cIMCode.hMainTask, "#{TTG_NL}#{TTG_TB}#{aIntHdr[1]}_#{VAR_BOOTCNT}++")
        build_int_raise(cElementCommon, aIntHdr[2], aIntHdr[3])
        cElementCommon.set_syscall(@cIMCode.hMainTask, "#{API_SLP_TSK}()")
        if (@cConf.get_api_support_dis_int() == true)
          build_dis_int(cElementCommon, aIntHdr[2], aIntHdr[3])
        end
        cElementCommon.set_checkpoint(@cIMCode.hMainTask)
        @cIMCode.add_element(cElementCommon)

        @cIMCode.set_testid_level("#{TTG_LBL_CHK_ENAINT}")
        @cIMCode.set_condition_level("#{TTG_LBL_CHK_ENAINT}")
        cElementIntHdr = IMCodeElement.new()
        cElementIntHdr.set_syscall(aIntHdr[0], "#{API_IWUP_TSK}(#{TTG_MAIN_TASK})")
        @cIMCode.add_element(cElementIntHdr)
      }
    end

    #================================================================
    # ��  ��: �ᥤ�󥿥�����GCOV�����򳫻Ϥ���
    #================================================================
    def build_main_task_gcov_start()
      # ���֥��饹�ǥ����С��饤�ɤ������Ѥ���
      abort(ERR_MSG % [__FILE__, __LINE__])
    end

    #================================================================
    # ��  ��: �ᥤ�󥿥����������ߤ�ȯ��������
    #================================================================
    def build_int_raise()
      # ���֥��饹�ǥ����С��饤�ɤ������Ѥ���
      abort(ERR_MSG % [__FILE__, __LINE__])
    end

    #================================================================
    # ��  ��: �ᥤ�󥿥�����dis_int��¹Ԥ���
    #================================================================
    def build_dis_int()
      # ���֥��饹�ǥ����С��饤�ɤ������Ѥ���
      abort(ERR_MSG % [__FILE__, __LINE__])
    end

    #================================================================
    # ������: TA_STA°���μ����ϥ�ɥ��stp_cyc��ȯ�Ԥ��륳���ɤ���������
    #================================================================
    def build_stp_cyc(hCyclicStaInfo)
      check_class(Hash, hCyclicStaInfo) # TA_STA°���μ����ϥ�ɥ����ϥå���

      cElement = IMCodeElement.new(:common)

      hCyclicStaInfo.each{|sObjectID, cObjectInfo|
        # �ᥤ�󥿥�������Ƭ��°����ǧ�ȥϥ�ɥ���߽�����Ԥ�
        cObjectInfo.gc_obj_ref_only_cyc(cElement, @cIMCode.hMainTask);
        cElement.set_syscall(@cIMCode.hMainTask, "#{API_STP_CYC}(#{sObjectID})")
        cElement.set_checkpoint(@cIMCode.hMainTask)
      }

      @cIMCode.add_element(cElement)
    end

    #================================================================
    # ������: TA_ENAINT°���γ���ߥ����ӥ��롼���󤬳��Ĥ����Ƥ�
    #         �������ֹ���Ф��Ƶ�ư��ǧ�Ѥγ���ߥ����ӥ��롼�����
    #         ��ư����dis_int����
    #         (����ߥϥ�ɥ��build_shared_proc_unit��Ǽ»�)
    #================================================================
    def build_ena_int_isr(hEnaIntIsrInfo)
      check_class(Hash, hEnaIntIsrInfo) # TA_ENAINT°���γ���ߥ����ӥ��롼����ξ���

      aEnaIntIsr = []
      aChkIsr = []

      # �оݤȤ������ñ�̤�ɬ�פʾ�������
      hEnaIntIsrInfo.each{|sObjectID, cObjectInfo|
        # Ʊ��������ֹ�Ͻ���
        if (!aChkIsr.include?(cObjectInfo.hState[TSR_PRM_INTNO]))
          hTempObject = cObjectInfo.dup
          hTempObject.sObjectID = "#{TTG_LBL_ISR}_#{cObjectInfo.hState[TSR_PRM_INTNO]}_#{TTG_LBL_CHK_ENAINT}";
          hTempObject.hState[TSR_PRM_ISRPRI] = 1;
          aEnaIntIsr.push(hTempObject)
        end

        aChkIsr.push(cObjectInfo.hState[TSR_PRM_INTNO])
      }

      # ��ư��ǧ�Ѥγ���ߥ����ӥ��롼�������Ͽ����ư����dis_int����
      aEnaIntIsr.each{|cEnaIntIsr|
        cElementCommon = IMCodeElement.new(:common)
        cElementCommon.set_global_var("#{TTG_LBL_ISR}_#{VAR_BOOTCNT}", "enum ENUM_#{TTG_LBL_ISR}", "#{TTG_LBL_ISR}_#{TTG_ENUM_INVALID}")
        cElementCommon.set_code(@cIMCode.hMainTask, "#{TTG_NL}#{TTG_TB}#{TTG_LBL_ISR}_#{VAR_BOOTCNT}++")
        build_int_raise(cElementCommon, cEnaIntIsr.hState[TSR_PRM_INTNO], cEnaIntIsr.hState[TSR_PRM_PRCID])
        cElementCommon.set_syscall(@cIMCode.hMainTask, "#{API_SLP_TSK}()")
        if (@cConf.get_api_support_dis_int() == true)
          build_dis_int(cElementCommon, cEnaIntIsr.hState[TSR_PRM_INTNO], cEnaIntIsr.hState[TSR_PRM_PRCID])
        end
        cElementCommon.set_checkpoint(@cIMCode.hMainTask)
        @cIMCode.add_element(cElementCommon)

        @cIMCode.set_testid_level("#{cEnaIntIsr.hState[TSR_PRM_INTNO]}_#{TTG_LBL_CHK_ENAINT}")
        @cIMCode.set_condition_level("#{cEnaIntIsr.hState[TSR_PRM_INTNO]}_#{TTG_LBL_CHK_ENAINT}")
        cElementIntIsr = IMCodeElement.new()
        cElementIntIsr.set_proc_unit(cEnaIntIsr.sObjectID, cEnaIntIsr.hState[TSR_PRM_BOOTCNT])
        cElementIntIsr.set_header(cEnaIntIsr.sObjectID, TSR_OBJ_ISR)
        cEnaIntIsr.gc_config(cElementIntIsr)
        hProcUnitInfo = {:id => cEnaIntIsr.sObjectID, :prcid => cEnaIntIsr.hState[TSR_PRM_PRCID], :bootcnt => TTG_MAIN_BOOTCNT}
        cElementIntIsr.set_syscall(hProcUnitInfo, "#{API_IWUP_TSK}(#{TTG_MAIN_TASK})")
        @cIMCode.add_element(cElementIntIsr)
      }

    end

    #================================================================
    # ������: �ᥤ�󥿥�������Ƭ��cp_state������å����륳���ɤ���������
    #================================================================
    def build_check_cp_state()
      cElement = IMCodeElement.new(:common)

      cElement.set_local_var(@cIMCode.hMainTask[:id], VAR_STATE, TYP_BOOL_T)
      cElement.set_code(@cIMCode.hMainTask, "#{TTG_NL}#{TTG_TB}#{VAR_STATE} = #{FNC_GET_CP_STATE}()")
      cElement.set_code(@cIMCode.hMainTask, "if (#{VAR_STATE} == false) {", false)
      cElement.set_indent(1)
      cElement.set_code(@cIMCode.hMainTask, "#{API_EXT_KER}()")
      cElement.unset_indent()
      cElement.set_code(@cIMCode.hMainTask, "}")

      @cIMCode.add_element(cElement)
    end

    #================================================================
    # ������: �ᥤ�󥿥�������Ƭ�ǳƽ����������Ԥ������ɤ���������
    #================================================================
    def build_initialize()
      cElement = IMCodeElement.new(:common)

      # �ƥ��ȥ饤�֥�����ѿ������
      cElement.set_code(@cIMCode.hMainTask, FNC_INITIALIZE_TEST_LIB)

      @cIMCode.add_element(cElement)
    end

    #================================================================
    # ������: ����������֥����ɤ��֤�
    #================================================================
    def get_result()
      return @cIMCode  # [IntermediateCode]��֥�����
    end

  end
end
