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
#  $Id: ProfileDirector.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"

module TTG

  #==================================================================
  # ���饹̾: ProfileDirector
  # ����  ��: ProfileBuilder�����Ѥ�����֥����ɤ��������륯�饹
  #==================================================================
  class ProfileDirector
    include CommonModule

    #================================================================
    # ������: ���󥹥ȥ饯��
    #================================================================
    def initialize(cProfileBuilder)
      check_class(ProfileBuilder, cProfileBuilder) # ProfileBuilder���饹�Υ��󥹥���

      @cProfileBuilder = cProfileBuilder.dup()

      @cConf = Config.new() # Config�����
    end


    #================================================================
    # ������: ���ꤵ�줿ProfileBuilder���Ѥ���build��Ԥ�
    #================================================================
    def build(aTestScenarios)
      check_class(Array, aTestScenarios) # �ƥ��ȥ��ʥꥪ������

      # ������롼����/��λ�롼���󥯥饹��������������
      bIsIniRtn = false
      bIsTerRtn = false
      aIniRtn = []
      aTerRtn = []
      aTestScenarios.each{|cTestScenario|
        if (@cProfileBuilder.exist_ini_rtn(cTestScenario) == true)
          aIniRtn.concat(cTestScenario.get_ini_ter_object_info_sort_by_id(TSR_OBJ_INIRTN))
          bIsIniRtn = true
        end
        if (@cProfileBuilder.exist_ter_rtn(cTestScenario) == true)
          aTerRtn.concat(cTestScenario.get_ini_ter_object_info_sort_by_id(TSR_OBJ_TERRTN))
          bIsTerRtn = true
        end
      }

      # ������롼����Υ����ɤ��������
      if (bIsIniRtn == true)
        # FMP�Ǥϥ����Х������롼����ǥƥ��ȥ饤�֥�����ѿ��ν������Ԥ�
        if (@cConf.is_fmp?())
          @cProfileBuilder.build_initialize_test_lib_ini_rtn()
        end

        @cProfileBuilder.build_ini_rtn(aIniRtn)

        # ������롼���󤬤���Ȥ��ϥᥤ�󥿥�������Ƭ��cp_state������å�����
        @cProfileBuilder.build_check_cp_state()
      else
        # ������롼����̵����硤�ᥤ�󥿥�������Ƭ�ǳƽ����������Ԥ�
        @cProfileBuilder.build_initialize()
      end


      # TA_STA°���μ����ϥ�ɥ�ξ�������
      hCyclicStaInfo = get_all_object_info(aTestScenarios, TSR_OBJ_CYCLE)
      # TA_STA°���μ����ϥ�ɥ餬����Ȥ��ϥᥤ�󥿥�������Ƭ�Ǿ��֥����å���stp_cyc����
      if (hCyclicStaInfo.empty?() == false)
        @cProfileBuilder.build_stp_cyc(hCyclicStaInfo)
      end

      # TA_ENAINT°���γ���ߥ����ӥ��롼����ξ�������
      hISRInfo = get_all_object_info(aTestScenarios, TSR_OBJ_ISR)
      # TA_ENAINT°���γ���ߥ����ӥ��롼���󤬤���Ȥ��ϳ���߳�ǧ��dis_int��ȯ�Ԥ���
      if (hISRInfo.empty?() == false)
        @cProfileBuilder.build_ena_int_isr(hISRInfo)
      end

      # ����ߥϥ�ɥ�ξ�������
      hIntHdrInfo = get_all_object_info(aTestScenarios, TSR_OBJ_INTHDR)
      # ����ߥϥ�ɥ餬����Ȥ��϶�ͭ����ñ��/�ؿ��������������߳�ǧ��dis_int��ȯ�Ԥ���
      if (hIntHdrInfo.empty?() == false)
        @cProfileBuilder.build_shared_proc_unit(hIntHdrInfo, TSR_OBJ_INTHDR)
      end

      # CPU�㳰�ϥ�ɥ�ξ�������
      hExceptionInfo = get_all_object_info(aTestScenarios, TSR_OBJ_EXCEPTION)
      # CPU�㳰�ϥ�ɥ餬����Ȥ��϶�ͭ����ñ��/�ؿ����������
      if (hExceptionInfo.empty?() == false)
        @cProfileBuilder.build_shared_proc_unit(hExceptionInfo, TSR_OBJ_EXCEPTION)
      end


      # GCOV��������� ���� ������롼����̵�����ν���(�ץ�ե�������˰ۤʤ�)
      if (@cConf.enable_gcov?() && (bIsIniRtn == false))
        @cProfileBuilder.build_main_task_gcov_start()
      end

      # ��֥����ɤ˥ƥ��ȥ��ʥꥪ���Ȥ�ɬ�פʾ�����ɲä���
      nCnt = 0
      nTotal = aTestScenarios.size()
      # ���Υƥ��ȥ��ʥꥪ�ˤ��������ư��ե饰��configure.yaml�Υե饰�ǽ����
      bPrevGainTime = @cConf.is_all_gain_time_mode?()
      aTestScenarios.each{|cTestScenario|
        nCnt += 1
        if (@cConf.is_no_progress_bar_mode?() == true)
          $stderr.puts "[TTG][#{"%5.1f" % (100 * nCnt.to_f / nTotal.to_f)}\% (#{"%4d" % nCnt}/#{"%4d" % nTotal})] #{cTestScenario.sTestID}"
        else
          print_progress("TTG", cTestScenario.sTestID, nCnt, nTotal)
        end

        @cProfileBuilder.build(cTestScenario, bPrevGainTime)
        bPrevGainTime = cTestScenario.bGainTime
      }
      # �ץ��쥹�С���ɽ���Υꥻ�å�
      if (@cConf.is_no_progress_bar_mode?() != true)
        finish_progress("TTG", nTotal)
      end


      # �Ǹ�Υ����å��ݥ���Ȥ������
      # ��λ�롼���󤬤������check_point����ext_ker��̵������check_finish
      @cProfileBuilder.build_finish_cp(bIsTerRtn)

      # ��λ�롼����Υ����ɤ��������
      if (bIsTerRtn == true)
        @cProfileBuilder.build_ter_rtn(aTerRtn)
      end
    end

    #================================================================
    # ��  ��: ���ꤷ�����֥������Ȥ����ƥ��ȥ��ʥꥪ�ξ�����֤�
    #         (����ߡ�CPU�㳰�������ϥ�ɥ�(TA_STA)�Τߤ˻��Ѥ���)
    #================================================================
    def get_all_object_info(aTestScenarios, sObjectType)
      check_class(Array, aTestScenarios) # ���ƥ��ȥ��ʥꥪ�ǡ���
      check_class(String, sObjectType)   # �оݤȤ��륪�֥������ȥ�����

      hAllObjectInfo = Hash.new()

      aTestScenarios.each{|cTestScenario|
        if (((sObjectType == TSR_OBJ_INTHDR) && (cTestScenario.exist_int_hdr() == true)) ||
            ((sObjectType == TSR_OBJ_ISR) && (cTestScenario.exist_isr_enaint() == true)) ||
            ((sObjectType == TSR_OBJ_EXCEPTION) && (cTestScenario.exist_exception() == true)) ||
            ((sObjectType == TSR_OBJ_CYCLE) && (cTestScenario.exist_cyclic_sta() == true)))
          hAllObjectInfo.update(cTestScenario.get_all_object_info(sObjectType)){|key, self_val, other_val|
            # bootcnt�Ϻ����ͤ�����
            if (self_val.hState[TSR_PRM_BOOTCNT] > other_val.hState[TSR_PRM_BOOTCNT])
              self_val
            else
              other_val
            end
          }
        end
      }

      return hAllObjectInfo  # [Hash]���֥������Ⱦ���ϥå���
    end

  end
end
